# frozen_string_literal: true

module Schematics
  module Behaviours
    module Numerable
      delegate :unit, :precision, to: :options

      def icon = :arrow_up_1_9 # rubocop:disable Naming/VariableNumber

      def validators
        super.merge(numericality: { allow_blank: })
      end

      # :reek:NilCheck
      def format(value)
        case value
        when nil, StandardError
          super
        else
          case unit
          when 'bytes'
            number_to_human_size(value, **{ precision: }.compact)
          when '%'
            number_to_percentage(value, **{ precision: }.compact)
          when '€', '$', '£'
            number_to_currency(value, **{ unit:, precision: }.compact)
          else
            [number_with_precision(value, **{ precision: }.compact), unit].compact.join(' ')
          end
        end
      end

      def migration_options
        super.concat %i[default]
      end
    end
  end
end
