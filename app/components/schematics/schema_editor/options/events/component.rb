# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Events
        class Component < ApplicationComponent
          delegate :name, to: :option
          delegate :collection, to: Schematics::Options::Icon, prefix: :icons
          delegate :object, to: :builder, private: true
          delegate :values, to: :object

          option :builder
          option :option

          def data = { controller: 'schema-editor--event-dropdown' }

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

          def include_hidden = false

          def maxlength = 50

          def events = Array(object.events&.map(&Schematics::Options::StateMachineEvent))

          def include_blank(name = nil)
            attribute_name = Schematics::Options::Wrapper.human_attribute_name('values') unless name
            attribute_name ||= Schematics::Options::StateMachineEvent.human_attribute_name(name)
            t('prompt', attribute_name: attribute_name.singularize.downcase)
          end
        end
      end
    end
  end
end
