# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Numerable
        class Component < Fields::Component
          delegate :greater_than,
                   :greater_than_or_equal_to,
                   :less_than,
                   :less_than_or_equal_to,
                   :equal_to,
                   :precision,
                   :unit,
                   to: :field,
                   private: true

          def step = (10**-precision.to_i).to_f

          def min
            equal_to || greater_than_or_equal_to || greater_than
          end

          def max
            equal_to || less_than_or_equal_to || less_than
          end

          def prepend
            return if inline?

            unit || super
          end
        end
      end
    end
  end
end
