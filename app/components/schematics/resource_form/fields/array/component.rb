# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Array
        class Component < Fields::Component
          def data = { controller: 'dropdown', 'dropdown-create-value': true }
        end
      end
    end
  end
end
