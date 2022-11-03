# frozen_string_literal: true

module Schematics
  module SchemaEditor
    class Component < ApplicationComponent
      DENYLIST = %i[Association Attribute Month StateMachineEvent Week Year].freeze
      delegate :persisted?, to: :resource
      option :resource

      def attribute_constants_collection
        (Attributes.constants - DENYLIST).map(&Attributes.method(:const_get))
      end

      def data = {
        'auto-save-target': 'form',
        'nested-form-target': 'form'
      }

      def schema = resource.data

      def entities = schema
        .entities
        .reject(&:core?)
        .sort_by(&:name)

      def url
        return schema_datasets_path unless persisted?

        schema_dataset_path(resource)
      end

      def form_method
        return :post unless persisted?

        :patch
      end
    end
  end
end
