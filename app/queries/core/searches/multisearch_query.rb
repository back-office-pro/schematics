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
          .map { |klass, documents| klass&.where(id: [documents.map(&:searchable_id)]) }
          .map { _1.accessible_by(ability) }
          .compact_blank
      end
    end
  end
end
