# frozen_string_literal: true

module Application
  module Searches
    class Ransack
      include Interactor
      LIMIT = 5
      delegate :query, :current_ability, to: :context, private: true

      def call
        context.suggestions = []
        context.typeahead = results.take(LIMIT)
        context.results = results
      end

      private

      def results
        @results ||= ::Tenant
                     .schema
                     .entities
                     .reject(&:hidden?)
                     .select(&:multisearchable?)
                     .map(&:model_class)
                     .map { _1.multisearch(query, current_ability) }
                     .map(&:load_async)
                     .reject(&:empty?)
      end
    end
  end
end
