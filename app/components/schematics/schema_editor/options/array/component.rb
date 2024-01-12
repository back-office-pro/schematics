# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Array
        class Component < Select::Component
          def data = {
            controller: 'dropdown',
            'dropdown-create-value': true,
            'dropdown-create-filter-value': '^[a-z_][a-z_]+$'
          }

          def values
            Array(object.public_send(name))
          end
        end
      end
    end
  end
end
