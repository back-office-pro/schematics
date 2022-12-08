# frozen_string_literal: true

module Schematics
  module Loadable
    extend ActiveSupport::Concern

    included do
      include ActiveStorageSupport::SupportForBase64
      include AASM
      attribute_method_suffix '_formatted'
      attribute :lock_version, default: 0
      strip_attributes
    end

    class_methods do
      attr_reader :concerns

      def inherited(subclass)
        super
        subclass.class_eval do
          superclass.concerns&.each(&method(:include))
          entity&.load
        end
      end

      def tenant
        @tenant ||= Tenant.new(name: module_parent.to_s)
      end

      def entity = tenant
        .schema
        .find_entity_by_name(name.demodulize.underscore)

      def filter_attributes = entity
        .non_renderable_attributes
        .map(&:name)
        .map(&:to_sym)

      def finder(id)
        case entity
        when Entities::Singleton
          instance
        else
          find(id)
        end
      end

      def reload_definitions!
        Object.__send__(:remove_const, name.to_sym)
        load ::Rails.root.join('app', 'models', "#{name}.rb")
        return unless ::Application.const_defined?(name.demodulize.to_sym)

        prepend(Application.const_get(name.demodulize.to_sym))
      end

      private

      def loadable(concerns: [])
        @concerns = concerns
      end
    end

    def attribute_formatted(attr)
      self
        .class
        .entity
        &.find_field_by_name(attr)
        &.format(public_send(attr)) || public_send(attr)
    end

    def associations(current_ability:, only: nil)
      self
        .class
        .entity
        .association_elements
        .select(&only)
        .map do |association|
          public_send(association.name)
            .preload(association.includes)
            .accessible_by(current_ability)
            .order(created_at: :desc)
        end.compact_blank
    end
  end
end
