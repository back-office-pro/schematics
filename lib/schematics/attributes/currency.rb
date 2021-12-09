# frozen_string_literal: true

module Schematics
  module Attributes
    class Currency < Float
      def format(value)
        value && number_to_currency(value, **{ unit:, precision: }.compact)
      end

      def icon
        :money_bill_wave
      end
    end
  end
end
