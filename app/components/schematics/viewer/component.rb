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
  module Viewer
    class Component < ApplicationComponent
      delegate :preferences, to: :current_user, private: true
      delegate :entity, to: :model_class
      delegate :icon, to: :entity
      option :resources

      class << self
        def build(resources:, viewer:)
          module_parent.const_get(viewer.to_s.camelize)::Component.new(resources:)
        end
      end

      protected

      def col_preference_class(field)
        preference = "col_#{entity.id}_#{field.id}"
        return preference if preferences.fetch(preference, true)

        "#{preference} d-none"
      end

      def model_class = resources.klass

      def tbody_css_classes = %w[animate__animated animate__slideInRight]

      def elements = entity
        .listable_elements
        .stable_sort_by(&:weight)
    end
  end
end
