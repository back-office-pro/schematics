# frozen_string_literal: true

module Schematics
  module Attributes
    class ModelField < String
      include Behaviours::Enumerable

      def format(value)
        return unless value

        class_name, field_name = value.split('#')
        return unless Object.const_defined?(class_name)

        class_name.constantize.human_attribute_name(field_name)
      end

      def values
        Schema
          .instance
          .entities
          .flat_map(&:renderable_fields)
          .map(&:method_name)
      end

      def icon
        :code
      end
    end
  end
end
