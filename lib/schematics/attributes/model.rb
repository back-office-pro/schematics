# frozen_string_literal: true

module Schematics
  module Attributes
    class Model < String
      include Behaviours::Enumerable

      def format(value)
        return unless value
        return unless Object.const_defined?(value)

        value.constantize.human_name.titleize
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
