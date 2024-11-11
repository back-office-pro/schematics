# frozen_string_literal: true

module Core
  module Searches
    class AutocompleteQuery < Schematics::ApplicationQuery
      LIMIT = 5

      def call(*, ability, query)
        PgSearch
          .multisearch(query)
          .select(:searchable_id, :searchable_type)
          .map { _1.searchable_type.safe_constantize&.preload_all&.where(id: _1.searchable_id) }
          .filter_map { _1.accessible_by(ability) }
          .compact_blank
          .flatten
          .take(LIMIT)
      end
    end
  end
end
