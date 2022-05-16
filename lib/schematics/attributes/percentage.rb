# frozen_string_literal: true

module Schematics
  module Attributes
    class Percentage < Float
      def unit = '%'
      def icon = :percent

      def format(value)
        value && number_to_percentage(value, **{ precision: }.compact)
      end
    end
  end
end
