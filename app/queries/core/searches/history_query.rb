# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Searches
    class HistoryQuery < Schematics::ApplicationQuery
      LIMIT = 5

      def call = where(model: nil)
        .where
        .not(query: nil)
        .order(created_at: :desc)
        .limit(LIMIT)
        .async_pluck(:query)
        .value
        .uniq
    end
  end
end
