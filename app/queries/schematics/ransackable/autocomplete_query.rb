# frozen_string_literal: true

module Schematics
  module Ransackable
    class AutocompleteQuery < ApplicationQuery
      LIMIT = 5

      def call(params, field, ability)
        left_joins(entity.joins)
          .ransack(parse_params(params))
          .tap { _1.sorts = "#{field} asc" }
          .result(distinct: true)
          .preload(entity.includes)
          .accessible_by(ability)
          .limit(LIMIT)
          .pluck(entity.find_field_by_name(field).to_sql)
      end

      private

      def parse_params(params)
        params
          .deep_flatten
          .transform_keys { entity.find_field_by_name(_1)&.search_query || _1 }
      end
    end
  end
end
