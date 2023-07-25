# frozen_string_literal: true

module Core
  module Searches
    class Ransack
      include Interactor
      LIMIT = 5
      delegate :query, :current_ability, to: :context, private: true

      def call
        context.suggestions = []
        context.typeahead = results.map(&:first).take(LIMIT)
        context.results = results
      end

      private

      memoize def results = ::Tenant
        .schema
        .entities
        .reject(&:hidden?)
        .select(&:multisearchable?)
        .map(&:model_class)
        .map { _1.multisearch(query, current_ability) }
        .reject(&:empty?)
    end
  end
end
