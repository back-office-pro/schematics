# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    class Time < Datetime
      def available_options = super.excluding(
        Options::StartDate,
        Options::EndDate
      )

      def format(value)
        value && localize(value, format: :time)
      end

      def icon = :clock
    end
  end
end
