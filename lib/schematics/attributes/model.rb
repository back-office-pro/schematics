# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Model < String
      include Behaviours::Enumerable

      def format(value)
        value
          &.safe_constantize
          &.human_name
          &.titleize || value
      end

      def values
        Schema
          .instance
          .entities
          .reject(&entity_type)
          .map(&:class_name)
      end

      def collection
        super.sort
      end

      def icon
        :project_diagram
      end

      private

      def entity_type
        return :core? if options.without_core?

        :hidden?
      end
    end
  end
end
