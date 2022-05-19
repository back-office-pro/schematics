# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Model < String
      include Behaviours::Enumerable

      def collection = super.sort

      def format(value)
        value
          &.safe_constantize
          &.human_name
          &.titleize || value
      end

      def icon = :project_diagram

      def inclusion_list
        return :model_app_entities_values if options.without_core?

        :model_entities_values
      end

      def values = Schema
        .instance
        .entities
        .reject(&entity_type)
        .map(&:class_name)

      private

      def entity_type
        return :core? if options.without_core?

        :hidden?
      end
    end
  end
end
