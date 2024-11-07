# frozen_string_literal: true

module Core
  module Searches
    class AutocompleteQuery < Schematics::ApplicationQuery
      LIMIT = 5

      def call(*, ability, query)
        Multisearch
          .call(query:, ability:)
          .to_h
          .fetch(:typeahead)
          .take(LIMIT)
      end
    end
  end
end
