# frozen_string_literal: true

module Application
  module Search
    class TypeaheadHistoryQuery < Schematics::ApplicationQuery
      LIMIT = 5

      def call(model, name)
        where(model:, query: nil)
          .order(created_at: :desc)
          .limit(LIMIT)
          .load_async
          .pluck(:filters)
          .pluck(name)
          .uniq
          .compact
      end
    end
  end
end
