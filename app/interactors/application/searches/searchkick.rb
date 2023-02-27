# frozen_string_literal: true

module Application
  module Searches
    class Searchkick
      include Interactor
      delegate :query, :current_ability, to: :context, private: true

      def call
        context.suggestions = suggestions
        context.results = results
      end

      private

      def results = multisearch.flat_map(&:results)

      def suggestions = multisearch
        .flat_map(&:suggestions)
        .uniq

      def multisearch
        @multisearch ||= ::Searchkick
                         .multi_search(searches)
                         .reject(&:empty?)
      end

      def searches = ::Tenant
        .schema
        .entities
        .reject(&:hidden?)
        .map(&:model_class)
        .map { _1.multisearch(query, current_ability) }
    end
  end
end
