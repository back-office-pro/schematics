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
    module Item
      class Component < ApplicationComponent
        ALPHABET = [*'1'..'9', *'a'..'z']
          .without('h', 's')
          .freeze

        delegate :preferences_sidebar_toggled, to: :current_user, private: true
        delegate :human_name, :human_name_plural, :entity, to: :@model_class
        delegate :icon, :enum_attributes, to: :entity
        with_collection_parameter :model_class

        def initialize(model_class:, model_class_counter:)
          super
          @model_class = model_class
          @counter = model_class_counter
        end

        def path = resources_path(@model_class)

        def css_classes = class_names(
          'nav-link',
          'p-0',
          'm-0',
          'text-secondary',
          'text-nowrap',
          active: request.path.start_with?(path)
        )

        def title = "#{human_name_plural.humanize} (#{shortcut})"

        def data = {
          controller: 'tooltip hotkey',
          'bs-placement': 'right',
          'bs-container': '.sidebar',
          'hotkey-shortcut-value': shortcut
        }

        def toggled_class
          'd-md-block' unless preferences_sidebar_toggled
        end

        private

        def shortcut = "Control+#{ALPHABET[@counter]}"
      end
    end
  end
end
