# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Boolean
        class Component < Fields::Component
          def switch = true
        end
      end
    end
  end
end
