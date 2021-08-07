# frozen_string_literal: true

module Schematics
  module Virtuals
    class Calculation < Virtual
      include Behaviours::Rangeable

      delegate :unit, :scale, to: :options

      def to_sql
        super.join
      end

      def format(value)
        case value
        when StandardError
          super
        else
          [value.round(scale.to_i), unit].compact.join(' ')
        end
      end

      def icon
        :square_root_alt
      end
    end
  end
end
