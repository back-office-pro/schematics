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
  module SchemaEditor
    module Options
      module Inputs
        module Events
          class Component < Inputs::Component
            delegate :collection, to: 'Schematics::Options::Icon', prefix: :icons
            delegate :object, to: :builder, private: true
            delegate :values, to: :object

            def data = { controller: 'schema-editor--modal-dropdown' }

            def name_data = { controller: 'schema-editor--special-characters' }

            def icon_data = { controller: 'dropdowns--fa-icons-dropdown' }

            def color_data = { controller: 'dropdowns--colors-dropdown' }

            def popover_data = {
              controller: 'popover schema-editor--variable-typeahead',
              'bs-trigger': 'hover',
              'bs-content': __schema_editor_trigger_popover,
              'bs-placement': 'bottom',
              'bs-html': true
            }

            def state_machine_event = Schematics::Options::StateMachineEvent.new(id: 'RANDOM_UUID')

            def colors_collection = Schematics::Options::StateMachineEvent::COLORS

            def floating = true # rubocop:disable Naming/PredicateMethod

            def required = true # rubocop:disable Naming/PredicateMethod

            def multiple = true # rubocop:disable Naming/PredicateMethod

            def maxlength = 50

            def events = Array(object.events&.map(&Schematics::Options::StateMachineEvent))

            def include_blank(name = nil)
              param = attribute_name('values') unless name
              param ||= Schematics::Options::StateMachineEvent.human_attribute_name(name)
              super(param)
            end
          end
        end
      end
    end
  end
end
