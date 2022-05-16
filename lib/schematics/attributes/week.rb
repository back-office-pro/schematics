# frozen_string_literal: true

module Schematics
  module Attributes
    class Week < Datetime
      def group_method = :group_by_week

      def format(value)
        value && localize(value, format: :week)
      end
    end
  end
end
