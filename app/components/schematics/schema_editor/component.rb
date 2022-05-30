# frozen_string_literal: true

module Schematics
  module SchemaEditor
    class Component < ApplicationComponent
      prepend ViewComponent::GlobalOutputBuffer

      def data = {
        'auto-save-target': 'form'
      }

      def entities = Schema
        .instance
        .entities
        .reject(&:core?)
        .select { Object.const_defined?(_1.class_name) }
        .sort_by { _1.model_class.human_name }

      def url = schema_datasets_path

      def wrapper = :input_group
    end
  end
end
