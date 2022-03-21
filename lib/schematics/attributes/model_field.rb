# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class ModelField < String
      include Behaviours::Enumerable
      delegate :depends_on, to: :options

      def format(value)
        return unless value

        class_name, field_name = value.split('#')
        class_name.constantize.human_attribute_name(field_name)
      rescue StandardError
        value
      end

      def values
        Schema
          .instance
          .entities
          .reject(&:hidden?)
          .flat_map(&:renderable_fields)
          .map(&:method_name)
      end

      def icon
        :code
      end
    end
  end
end
