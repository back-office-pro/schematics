# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Events
        class Component < ApplicationComponent
          delegate :collection, to: Schematics::Options::Icon, prefix: :icons
          delegate :object, to: :builder, private: true
          delegate :values, to: :object

          option :builder
          option :name

          def data = { controller: 'schema-editor--event-dropdown' }

          def name_data = { controller: 'schema-editor--special-characters' }

          def icon_data = { controller: 'dropdowns--fa-icons-dropdown' }

          def color_data = { controller: 'dropdowns--colors-dropdown' }

          def callback_data = {
            controller: 'popover schema-editor--variable-typeahead',
            'bs-toggle': 'popover',
            'bs-trigger': 'hover',
            'bs-content': Schematics::SchemaEditor::Trigger::Popover::Component.new.to_html,
            'bs-placement': 'bottom',
            'bs-html': true
          }

          def colors_collection = Schematics::Options::StateMachineEvent::COLORS

          def floating = true

          def required = true

          def multiple = true

          def include_hidden = false

          def maxlength = 50

          def events = Array(
            object
              .events
              &.map { Schematics::Options::StateMachineEvent.new(**_1) }
          )
        end
      end
    end
  end
end
