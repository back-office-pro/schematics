# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Loadable
    extend ActiveSupport::Concern
    ASSOCIATIONS_LIMIT = 100

    included do
      include ActiveStorageSupport::SupportForBase64
      include AASM
      attribute_method_suffix '_formatted'
      attribute :lock_version, default: 0
      broadcasts_refreshes
    end

    class_methods do
      # :reek:Attribute
      attr_accessor :concerns

      def inherited(subclass)
        super
        subclass.class_eval do
          superclass.concerns&.each(&method(:include))
          prepend Core.const_get(name.demodulize) if Object.const_defined?("Core::#{name.demodulize}")
          entity&.model_elements&.each do
            eval it, binding, __FILE__, __LINE__ # rubocop:disable Security/Eval
          end
        end
      end

      def schema
        ::SchemaCache.fetch(name.deconstantize.underscore)
      end

      def entity
        schema.find_entity_by_name(name.start_with?('ActiveStorage') ? name.underscore : name.demodulize.underscore)
      end

      def filter_attributes = entity
        .non_renderable_attributes
        .map(&:column_name)
        .map(&:to_sym)

      def cached_attributes = entity
        .attributes
        .select(&:cached?)
        .map(&:name)
        .map(&:to_sym)

      def finder(id)
        case entity
        when Entities::Singleton
          instance
        else
          friendly.find(id)
        end
      end

      def create_without_validations(resources)
        Array
          .wrap(resources)
          .map { |attributes| new(**attributes).tap { it.save(validate: false) } }
      end

      def preload_all = includes(entity.includes).preload(entity.preload)

      def print_model
        print entity.model_elements.map(&:to_str).join # rubocop:disable Rails/Output
      end

      def load!(name)
        entity = schema.find_entity_by_name(name.to_s.underscore)
        return unless entity

        unless Object.const_defined?(name)
          Rails.logger.info "Loading #{name}..."
          eval(entity, binding, __FILE__, __LINE__) # rubocop:disable Security/Eval
        end

        const_get(name)
      end

      private

      def loadable(concerns: [])
        self.concerns = concerns
      end
    end

    def attribute_formatted(attr)
      self
        .class
        .entity
        &.find_field_by_name(attr)
        &.format(public_send(attr)) || public_send(attr)
    end

    # :reek:BooleanParameter :reek:ControlParameter
    def associations(ability, dependent: false)
      self
        .class
        .entity
        .association_elements
        .then_tap { it.grep_v(Associations::HasAndBelongsToMany).select(&:required?) if dependent }
        .map { public_send(it.name).includes(it.includes).with_string_translations }
        .map { it.accessible_by(ability).order(created_at: :desc) }
        .map { it.limit(ASSOCIATIONS_LIMIT) }
        .compact_blank
    end
  end
end
