# frozen_string_literal: true

module Schematics
  module SearchIndexes
    class AutocompleteQuery < ApplicationQuery
      LIMIT = 5

      def call(*, ability, query)
        where("#{table_name} MATCH ?", query.to_json)
          .select(:searchable_id, :searchable_type)
          .order(:rank)
          .map { it.searchable_type.safe_constantize&.preload_all&.where(id: it.searchable_id) }
          .filter_map { it.accessible_by(ability) }
          .compact_blank
          .flatten
          .take(LIMIT)
      end
    end
  end
end
