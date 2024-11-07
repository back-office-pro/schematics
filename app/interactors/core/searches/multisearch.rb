# frozen_string_literal: true

module Core
  module Searches
    class Multisearch
      include Interactor
      delegate :query, :ability, to: :context, private: true

      def call
        context.suggestions = []
        context.typeahead = results.map(&:first)
        context.results = results
      end

      private

      memoize def results = ::Tenant
        .schema
        .entities
        .reject(&:hidden?)
        .select(&:multisearchable?)
        .filter_map(&:model_class)
        .map { _1.multisearch(query, ability) }
        .reject(&:empty?)
    end
  end
end
