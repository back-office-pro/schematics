# frozen_string_literal: true

module Schematics
  module Filter
    module Range
      module Bound
        class Component < Filter::Component
          def initialize(field:, comparison:)
            super(field:)
            @comparison = comparison
          end

          def date?
            type == :date
          end

          def field_tag = :"#{type}_field_tag"

          def filter_name
            super + "[#{@comparison}]"
          end

          def onchange
            super if date?
          end

          def type
            case @field
            when Attributes::Date
              :date
            else
              :number
            end
          end

          def unit
            @field.try(:unit)
          end

          def value
            super&.dig(@comparison)
          end
        end
      end
    end
  end
end
