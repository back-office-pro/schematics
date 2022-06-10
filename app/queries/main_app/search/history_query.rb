# frozen_string_literal: true

module MainApp
  module Search
    class HistoryQuery < Schematics::ApplicationQuery
      LIMIT = 5

      def call = where(model: nil)
        .where
        .not(query: nil)
        .order(created_at: :desc)
        .limit(LIMIT)
        .load_async
        .pluck(:query)
        .uniq
    end
  end
end
