# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Loadable
    extend ActiveSupport::Concern

    ASSOCIATIONS_LIMIT = 100
    SEMAPHORE = Mutex.new.freeze

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
          entity&.model_elements&.each do |model_element|
            eval model_element, binding, __FILE__, __LINE__ # rubocop:disable Security/Eval
          end
        end
      end

      def entity
        SchemaCache.find_entity_by_name(entity_name)
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
          .map { |attributes| new(**attributes).tap { _1.save(validate: false) } }
      end

      def preload_all = includes(entity.includes).preload(entity.preload)

      def print_model
        print entity.model_elements.map(&:to_str).join # rubocop:disable Rails/Output
      end

      def model_name
        SEMAPHORE.synchronize do
          @model_name ||= ActiveModel::Name.new(self, nil, entity&.core? ? name : name.demodulize)
        end
      end

      private

      def entity_name = name
        .demodulize
        .underscore

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
        .then_tap { _1.grep_v(Associations::HasAndBelongsToMany).select(&:required?) if dependent }
        .map { public_send(_1.name).includes(_1.includes).with_string_translations }
        .map { _1.accessible_by(ability).order(created_at: :desc) }
        .map { _1.limit(ASSOCIATIONS_LIMIT) }
        .compact_blank
    end

    protected

    def raise_nested_attributes_record_not_found!(*) = nil
  end
end
