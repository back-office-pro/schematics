# frozen_string_literal: true

module Schematics
  module Attributes
    class Currency < Float
      include Behaviours::Unincrementable

      def format(value)
        value && number_to_currency(value, **{ unit:, precision:, separator:, delimiter: }.compact)
      end

      def openai_description = 'An attribute which represents a currency symbol'

      def icon = :money_bill_wave
    end
  end
end
