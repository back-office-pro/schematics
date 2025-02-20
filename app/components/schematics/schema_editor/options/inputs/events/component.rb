# Copyright © 2025 Dev & Software. All rights reserved.
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

            def floating = true

            def required = true

            def multiple = true

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
