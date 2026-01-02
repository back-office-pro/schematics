# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
