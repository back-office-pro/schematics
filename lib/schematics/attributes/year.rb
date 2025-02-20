# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    class Year < Datetime
      def format(value)
        value && localize(value, format: :year)
      end

      def group_method = :group_by_year
    end
  end
end
