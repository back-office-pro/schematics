# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class ModelField < String
      include Behaviours::Enumerable
      delegate :depends_on, to: :options

      def collection = super.sort
      def icon = :code

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
          .flat_map(&:"#{field_type}_fields")
          .map(&:method_name)
      end

      private

      def field_type = options.type || 'renderable_with_created_ats'
    end
  end
end
