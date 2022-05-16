# frozen_string_literal: true

module Schematics
  module Attributes
    class Year < Datetime
      def group_method = :group_by_year

      def format(value)
        value && localize(value, format: :year)
      end
    end
  end
end
