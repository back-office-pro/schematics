# frozen_string_literal: true

module Core
  module Searches
    class AutocompleteQuery < Schematics::ApplicationQuery
      LIMIT = 5

      def call(*, ability, query)
        PgSearch
          .multisearch(query)
          .accessible_by(ability)
          .limit(LIMIT)
      end
    end
  end
end
