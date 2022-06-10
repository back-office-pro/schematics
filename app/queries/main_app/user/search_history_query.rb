# frozen_string_literal: true

module MainApp
  module User
    class SearchHistoryQuery < Schematics::ApplicationQuery
      LIMIT = 5

      def call(searches)
        searches
          .where(model: nil)
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
end
