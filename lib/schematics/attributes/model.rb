# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Model < String
      include Behaviours::Enumerable

      def format(value)
        value && value.constantize.human_name.titleize rescue value
      end

      def values
        Schema
          .instance
          .entities
          .reject(&:hidden?)
          .map(&:class_name)
      end

      def icon
        :project_diagram
      end
    end
  end
end
