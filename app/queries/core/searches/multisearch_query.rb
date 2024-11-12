# frozen_string_literal: true

module Core
  module Searches
    class MultisearchQuery < Schematics::ApplicationQuery
      def call(query, ability)
        PgSearch
          .multisearch(query)
          .select(:searchable_id, :searchable_type)
          .group_by(&:searchable_type)
          .transform_keys(&:safe_constantize)
          .map { |klass, documents| klass&.preload_all&.where(id: [documents.map(&:searchable_id)]) } # rubocop:disable Layout/LineLength
          .filter_map { _1.accessible_by(ability) }
          .compact_blank
      end
    end
  end
end
