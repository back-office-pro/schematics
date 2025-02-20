# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    class Month < Datetime
      def format(value)
        value && localize(value, format: :month)
      end

      def group_method = :group_by_month
    end
  end
end
