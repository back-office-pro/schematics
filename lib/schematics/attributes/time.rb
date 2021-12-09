# frozen_string_literal: true

module Schematics
  module Attributes
    class Time < Datetime
      def format(value)
        value && localize(value, format: '%H:%M')
      end

      def icon
        :clock
      end
    end
  end
end
