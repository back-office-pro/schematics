# frozen_string_literal: true

module Schematics
  module SearchIndexes
    class MultisearchQuery < ApplicationQuery
      def call(query, ability)
        where("#{table_name} MATCH ?", query)
          .select(:searchable_id, :searchable_type)
          .ranked
          .group_by(&:searchable_type)
          .transform_keys(&:safe_constantize)
          .map { |klass, records| klass&.preload_all&.where(id: [records.map(&:searchable_id)]) }
          .filter_map { _1.accessible_by(ability) }
          .compact_blank
      end
    end
  end
end
