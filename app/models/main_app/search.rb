# frozen_string_literal: true

module MainApp
  module Search
    extend ActiveSupport::Concern

    HISTORY_LIMIT = 5

    class_methods do
      def user_search_history(user)
        where(user:, model: nil)
          .where
          .not(query: nil)
          .order(created_at: :desc)
          .limit(HISTORY_LIMIT)
          .pluck(:query)
          .uniq
      end

      def user_typeahead_history(user, model, name)
        where(user:, model:, query: nil)
          .order(created_at: :desc)
          .limit(HISTORY_LIMIT)
          .pluck(:filters)
          .pluck(name)
          .uniq
          .compact
      end
    end
  end
end
