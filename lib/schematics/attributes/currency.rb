# frozen_string_literal: true

module Schematics
  module Attributes
    class Currency < Float
      def icon = :money_bill_wave

      def format(value)
        value && number_to_currency(value, **{ unit:, precision: }.compact)
      end
    end
  end
end
