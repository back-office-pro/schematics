# frozen_string_literal: true

module Core
  module Searches
    class Searchkick
      include Interactor
      delegate :query, :ability, to: :context, private: true

      def call
        context.suggestions = results.flat_map(&:suggestions).uniq
        context.typeahead = results.flat_map(&:results)
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
        .map { _1.multisearch(query, ability) }
    end
  end
end
