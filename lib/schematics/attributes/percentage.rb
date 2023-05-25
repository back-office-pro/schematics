# frozen_string_literal: true

module Schematics
  module Attributes
    class Percentage < Float
      def format(value)
        value && number_to_percentage(value, **{ precision:, separator: }.compact)
      end

      def icon = :percent

      def unit = '%'
    end
  end
end
