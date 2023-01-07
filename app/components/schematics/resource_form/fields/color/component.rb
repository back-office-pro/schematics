# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Color
        class Component < Fields::Component
          def control_class
            super + ' form-control-color'
          end
        end
      end
    end
  end
end
