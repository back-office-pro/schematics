# frozen_string_literal: true

module Schematics
  module Attributes
    class Datetime < Date
      def format(value)
        value && localize(value, format: :long)
      end

      def open_api_type = ::DateTime
    end
  end
end
