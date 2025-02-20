# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    class Currency < Float
      include Behaviours::Unincrementable

      def format(value)
        value && number_to_currency(value, **{ unit:, precision:, separator: }.compact)
      end

      def icon = :money_bill_wave
    end
  end
end
