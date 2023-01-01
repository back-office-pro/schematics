# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Events
        class Component < ApplicationComponent
          delegate :object, to: :builder, private: true
          renders_one_form :builder
          option :builder
          option :name

          def data(icon = :location_arrow)
            {
              controller: 'dropdowns--fa-icons-dropdown',
              'dropdowns--fa-icons-dropdown-selected-value': icon.to_s.dasherize
            }
          end

          def events
            object.events&.map { Attributes::StateMachineEvent.new(**_1) } || []
          end

          def wrapper = :input_group
        end
      end
    end
  end
end
