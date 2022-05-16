# frozen_string_literal: true

module Schematics
  module Attributes
    class Month < Datetime
      def group_method = :group_by_month

      def format(value)
        value && localize(value, format: :month)
      end
    end
  end
end
