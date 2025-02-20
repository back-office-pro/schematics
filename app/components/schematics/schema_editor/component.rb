# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SchemaEditor
    class Component < ApplicationComponent
      delegate :new_record?, :errors, to: :resource
      delegate :collection, to: 'Schematics::Attributes::Attribute', prefix: :attributes
      option :resource

      def data = { 'auto-save-target': 'form', 'bs-parent': '#selector' }

      def css_classes = %w[schema-editor collapse show]

      def schema = resource.data

      def entities = schema
        .entities
        .reject(&:core?)
        .sort_by(&:name)

      def url
        return resources_path(::Migration) if new_record?

        resource_path(resource)
      end

      def form_method
        return :post if new_record?

        :patch
      end
    end
  end
end
