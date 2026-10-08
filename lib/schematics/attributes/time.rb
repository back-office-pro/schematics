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

      def openai_description = 'An attribute which represents a time'

      def icon = :clock
    end
  end
end
