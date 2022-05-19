# frozen_string_literal: true

module Schematics
  module Loadable
    extend ActiveSupport::Concern

    included do
      include ActiveStorageSupport::SupportForBase64
      include AASM
      strip_attributes
      attribute_method_suffix '_formatted'
    end

    class_methods do
      attr_reader :concerns

      def inherited(subclass)
        super
        subclass.class_eval do
          superclass.concerns.each(&method(:include))
          entity&.load
        end
      end

      def entity = Schema
        .instance
        .find_entity_by_name(name.underscore)

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

    def model_app_entities_values = Schema
      .instance
      .entities
      .reject(&:hidden?)
      .reject(&:core?)
      .map(&:class_name)

    def model_entities_values = Schema
      .instance
      .entities
      .reject(&:hidden?)
      .map(&:class_name)

    def model_field_numerable_values = Schema
      .instance
      .entities
      .reject(&:hidden?)
      .flat_map(&:numerable_fields)
      .map(&:method_name)

    def model_field_renderable_with_created_ats_values = Schema
      .instance
      .entities
      .reject(&:hidden?)
      .flat_map(&:renderable_with_created_ats_fields)
      .map(&:method_name)
  end
end
