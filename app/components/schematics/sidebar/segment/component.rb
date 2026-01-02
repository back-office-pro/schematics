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
  module Sidebar
    module Segment
      class Component < ApplicationComponent
        delegate :preferences_sidebar_toggled, to: :current_user, private: true
        delegate :values, :format, to: :@attribute
        with_collection_parameter :attribute

        def initialize(attribute:, model_class:)
          super
          @attribute = attribute
          @model_class = model_class
        end

        def path(value)
          resources_path(@model_class, filter_key => { @attribute.name => value })
        end

        def css_classes(value)
          class_names(
            'nav-link',
            'p-0',
            'm-0',
            'text-truncate',
            active: current_page?(path(value), check_parameters: true)
          )
        end

        def toggled_class
          'd-md-block' unless preferences_sidebar_toggled
        end

        def render? = request
          .path
          .start_with?(resources_path(@model_class))

        private

        def filter_key = Ransack.options[:search_key]
      end
    end
  end
end
