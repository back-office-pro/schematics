# frozen_string_literal: true

module Core
  module Searches
    class TypeaheadHistoryQuery < Schematics::ApplicationQuery
      LIMIT = 5

      def call(model, name)
        where(model:, query: nil)
          .order(created_at: :desc)
          .limit(LIMIT)
          .async_pluck(:filters)
          .value
          .pluck(name)
          .uniq
          .compact
      end
    end
  end
end
