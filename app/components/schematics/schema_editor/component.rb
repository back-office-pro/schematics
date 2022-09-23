# frozen_string_literal: true

module Schematics
  module SchemaEditor
    class Component < ApplicationComponent
      DENYLIST = %i[Association Attribute Month StateMachineEvent Week Year].freeze

      def initialize(schema:)
        super
        @schema = schema
      end

      def attribute_constants_collection
        (Attributes.constants - DENYLIST).map(&Attributes.method(:const_get))
      end

      def data = {
        'auto-save-target': 'form',
        'nested-form-target': 'form'
      }

      def entities = @schema
        .entities
        .reject(&:core?)
        .sort_by(&:name)

      def url = schema_datasets_path

      def wrapper = :input_group
    end
  end
end
