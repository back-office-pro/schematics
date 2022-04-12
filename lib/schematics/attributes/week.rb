# frozen_string_literal: true

module Schematics
  module Attributes
    class Week < Datetime
      def format(value)
        value && localize(value, format: :week)
      end

      def group_method
        :group_by_week
      end
    end
  end
end
