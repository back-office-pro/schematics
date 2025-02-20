# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class ModelField < String
      include Behaviours::Enumerable
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      delegate :depends_on, to: :options

      def available_options = super.push(
        Options::DependsOn,
        Options::Type
      )

      def collection = super.sort

      def format(value)
        return unless value

        class_name, field_name = value.split('#')
        class_name.constantize.human_attribute_name(field_name)
      rescue StandardError
        value
      end

      def icon = :code

      def validators = super.merge(inclusion: nil)

      def values = entity
        .schema
        .entities
        .reject(&:hidden?)
        .flat_map(&fields_type)
        .map(&:method_name)

      private

      def fields_type = options
        .fetch(:type, :renderable_with_created_ats_fields)
        .to_sym
    end
  end
end
