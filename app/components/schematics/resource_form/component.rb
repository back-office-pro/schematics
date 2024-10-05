# frozen_string_literal: true

module Schematics
  module ResourceForm
    class Component < ApplicationComponent
      delegate :persisted?, to: :resource, private: true
      use_helpers :rich_text_area_tag, :turbo_frame_request?

      option :resource
      option :url, optional: true
      option :attributes, default: -> { resource.class.entity.fillable_elements }
      option :cancel_path, default: -> { resource }

      def attributes
        return super unless persisted?

        super.select { can?(:update, resource, _1.name) }
      end

      def wrapper_class
        'd-flex' if turbo_frame_request?
      end

      def data = { controller: 'nested-form', 'auto-save-target': 'form' }

      def layout
        return :inline if turbo_frame_request?

        :vertical
      end
    end
  end
end
