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

          def field_tag
            :"#{type}_field_tag"
          end

          def type
            @field.try(:input_type) || :number
          end

          def filter_name
            super + "[#{@comparison}]"
          end

          def value
            super&.dig(@comparison)
          end

          def unit
            @field.try(:unit)
          end

          def date?
            type == :date
          end
        end
      end
    end
  end
end
