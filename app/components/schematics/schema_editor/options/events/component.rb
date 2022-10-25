# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Events
        class Component < ApplicationComponent
          renders_one_form :builder
          option :builder

          def data(icon = :location_arrow)
            {
              controller: 'dropdown',
              'dropdown-data-value': YAML
                .load_file(Schematics::Engine.root.join('lib', 'font_awesome_icons.yml'))
                .map do |text|
                  {
                    innerHTML: fa_icon(text, class: 'fa-fw', size: '2x'),
                    selected: text == icon.to_s,
                    text:
                  }
                end
            }
          end

          def events
            builder.object.events&.map { Attributes::StateMachineEvent.new(**_1) } || []
          end

          def wrapper = :input_group
        end
      end
    end
  end
end
