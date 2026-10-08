# frozen_string_literal: true

module Schematics
  module Attributes
    class Datetime < Date
      def format(value)
        value && localize(value, format: :long)
      end

      def openai_description = 'An attribute which represents a date with a time'

      def open_api_schema_type = 'datetime'
    end
  end
end
