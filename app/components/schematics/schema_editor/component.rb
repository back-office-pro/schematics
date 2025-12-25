# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module SchemaEditor
    class Component < ApplicationComponent
      delegate :new_record?, :errors, to: :resource
      delegate :collection, to: 'Schematics::Attributes::Attribute', prefix: :attributes
      delegate :bootstrap_form_with, to: :helpers
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
