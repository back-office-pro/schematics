# frozen_string_literal: true

module Schematics
  module Attributes
    class Model < String
      include Behaviours::Enumerable

      def format(value)
        value && value.constantize.human_name.titleize rescue value
      end

      def values
        Schema
          .instance
          .entities
          .map(&:class_name)
      end

      def icon
        :project_diagram
      end
    end
  end
end
