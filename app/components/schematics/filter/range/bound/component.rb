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
  module Filter
    module Range
      module Bound
        class Component < Filter::Component
          option :comparison

          def date?
            type == :date
          end

          def field_tag = :"#{type}_field_tag"

          def filter_name
            super + "[#{comparison}]"
          end

          def onchange
            super if date?
          end

          def type
            case field
            when Attributes::Date
              :date
            else
              :number
            end
          end

          def unit
            field.try(:unit)
          end

          def value
            super&.dig(comparison)
          end
        end
      end
    end
  end
end
