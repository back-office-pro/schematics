# frozen_string_literal: true

module Schematics
  module ResourceForm
    class Component < ApplicationComponent
      delegate :rich_text_area_tag, to: :helpers
      delegate :persisted?, to: :resource, private: true

      option :resource
      option :url, optional: true
      option :attributes, default: proc { resource.class.entity.fillable_elements }
      option :cancel_path, default: proc { resource }

      def attributes
        return super unless persisted?

        super.select { can?(:update, resource, _1.name) }
      end

      def turbo? = request
        .headers['Turbo-Frame']
        .present?

      def data = { 'auto-save-target': 'form' }

      def layout
        return :inline if turbo?

        :default
      end
    end
  end
end
