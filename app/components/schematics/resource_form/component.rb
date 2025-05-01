# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ResourceForm
    class Component < ApplicationComponent
      delegate :persisted?, to: :@resource, private: true
      use_helpers :rich_textarea_tag, :turbo_frame_request?

      def initialize(resource:, url: nil, cancel_path: nil, attributes: nil)
        super
        @resource = resource
        @url = url
        @cancel_path = cancel_path
        @attributes = attributes || resource.class.entity.fillable_elements
      end

      def url
        @url || default_url
      end

      def cancel_path
        @cancel_path || resource_path(@resource)
      end

      def attributes
        return @attributes unless persisted?

        @attributes.select { can?(:update, @resource, _1.name) }
      end

      def wrapper_class
        'd-flex' if turbo_frame_request?
      end

      def data = { controller: 'nested-form', 'auto-save-target': 'form' }

      def layout
        return :inline if turbo_frame_request?

        :vertical
      end

      private

      def default_url
        return resource_path(@resource) if persisted?

        resources_path(@resource.class)
      end
    end
  end
end
