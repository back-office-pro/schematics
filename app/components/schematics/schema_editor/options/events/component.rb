# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Events
        class Component < ApplicationComponent
          delegate :object, to: :builder, private: true
          delegate :values, to: :object
          option :builder
          option :name

          def data = { controller: 'schema-editor--event-dropdown' }

          def icon_data(icon = :location_arrow)
            {
              controller: 'dropdowns--fa-icons-dropdown',
              'dropdowns--fa-icons-dropdown-selected-value': icon.to_s.dasherize
            }
          end

          def color_data(color = :primary)
            {
              controller: 'dropdowns--colors-dropdown',
              'dropdowns--colors-dropdown-selected-value': color
            }
          end

          def floating = true

          def required = true

          def events = object
            .events
            &.map { Schematics::Options::StateMachineEvent.new(**_1) } || []
        end
      end
    end
  end
end
