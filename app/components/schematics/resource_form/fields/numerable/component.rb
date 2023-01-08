# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Numerable
        class Component < Fields::Component
          def step = (10**-field.precision.to_i).to_f

          def prepend
            return if inline?

            field.unit || super
          end
        end
      end
    end
  end
end
