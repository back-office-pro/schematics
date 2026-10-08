# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module ResourceForm
    class Component < ApplicationComponent
      delegate :persisted?, to: :@resource, private: true
      delegate :turbo_frame_request?, :bootstrap_form_with, to: :helpers

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

        @attributes.select { can?(:update, @resource, it.name) }
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
