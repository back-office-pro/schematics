# frozen_string_literal: true

module Schematics
  module Attributes
    class Time < Datetime
      def icon = :clock

      def format(value)
        value && localize(value, format: :time)
      end
    end
  end
end
