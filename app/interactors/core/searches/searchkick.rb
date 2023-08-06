# frozen_string_literal: true

module Core
  module Searches
    class Searchkick
      include Interactor
      LIMIT = 5
      delegate :query, :current_ability, to: :context, private: true

      def call
        context.suggestions = results.flat_map(&:suggestions).uniq
        context.typeahead = results.flat_map(&:results).take(LIMIT)
        context.results = results
      end

      private

      memoize def results = ::Searchkick
        .multi_search(searches)
        .reject(&:empty?)

      def searches = ::Tenant
        .schema
        .entities
        .reject(&:hidden?)
        .filter_map(&:model_class)
        .map { _1.multisearch(query, current_ability) }
    end
  end
end
