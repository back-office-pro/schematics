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
          entity&.model_elements&.each(&method(:eval))
        end
      end

      def entity = ::Tenant
        .schema
        .find_entity_by_name(name.underscore)

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
          find_by(id: UUID::Shortener.expand(id)) || friendly.find(id)
        end
      end

      def preload_all = includes(entity.includes).preload(entity.preload)

      def reload_definitions!
        return false unless model_filepath

        Object.__send__(:remove_const, name.to_sym)
        load(model_filepath)
      end

      def print_model
        print entity.model_elements.map(&:to_str).join # rubocop:disable Rails/Output
      end

      private

      def loadable(concerns: [])
        self.concerns = concerns
      end

      def model_filepath
        return if entity.existing?
        return Engine.root.join('app', 'models', 'core', "#{name.underscore}.rb") if entity.core?

        ::Rails.root.join('app', 'models', "#{name.underscore}.rb")
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
  end
end
