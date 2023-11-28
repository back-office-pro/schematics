# frozen_string_literal: true

module Schematics
  module ResourceForm
    class Component < ApplicationComponent
      delegate :persisted?, to: :resource, private: true
      use_helpers :rich_text_area_tag

      option :resource
      option :url, optional: true
      option :attributes, default: -> { resource.class.entity.fillable_elements }
      option :cancel_path, default: -> { resource }

      def attributes
        return super unless persisted?

        super.select { can?(:update, resource, _1.name) }
      end

      def wrapper_class
        'd-flex' if turbo?
      end

      def turbo? = request
        .headers['Turbo-Frame']
        .present?

      def data = { controller: 'nested-form', 'auto-save-target': 'form' }

      def layout
        return :inline if turbo?

        :vertical
      end
    end
  end
end
