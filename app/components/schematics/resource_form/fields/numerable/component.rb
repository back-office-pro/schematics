# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Numerable
        class Component < Fields::Component
          delegate :options, to: :field, private: true
          delegate :greater_than,
                   :greater_than_or_equal_to,
                   :less_than,
                   :less_than_or_equal_to,
                   :equal_to,
                   to: :options,
                   private: true

          def step = (10**-field.precision.to_i).to_f

          def min
            equal_to || greater_than_or_equal_to || greater_than
          end

          def max
            equal_to || less_than_or_equal_to || less_than
          end

          def prepend
            return if inline?

            field.unit || super
          end
        end
      end
    end
  end
end
