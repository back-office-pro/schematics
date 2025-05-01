# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SearchIndexes
    class AutocompleteQuery < ApplicationQuery
      LIMIT = 5

      def call(*, ability, query)
        where("#{table_name} MATCH ?", query.to_json)
          .select(:searchable_id, :searchable_type)
          .order(:rank)
          .map { _1.searchable_type.safe_constantize&.preload_all&.where(id: _1.searchable_id) }
          .filter_map { _1.accessible_by(ability) }
          .compact_blank
          .flatten
          .take(LIMIT)
      end
    end
  end
end
