# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Numerable
        class Component < Fields::Component
          def step = :any

          def prepend
            return if inline?

            field.try(:unit) || super
          end
        end
      end
    end
  end
end
