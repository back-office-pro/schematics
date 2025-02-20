# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SearchIndexes
    class MultisearchQuery < ApplicationQuery
      def call(query, ability) # rubocop:disable Metrics/CyclomaticComplexity
        where("#{table_name} MATCH ?", query.to_json)
          .select(:searchable_id, :searchable_type)
          .order(:rank)
          .group_by(&:searchable_type)
          .transform_keys(&:safe_constantize)
          .map { |klass, records| klass&.preload_all&.where(id: [records.map(&:searchable_id)]) }
          .filter_map { it.accessible_by(ability) }
          .compact_blank
      end
    end
  end
end
