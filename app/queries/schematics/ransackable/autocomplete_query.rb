# frozen_string_literal: true

module Schematics
  module Ransackable
    class AutocompleteQuery < ApplicationQuery
      include Filterable
      LIMIT = 5

      def call(params, field, ability)
        left_joins(entity.joins)
          .ransack(parse_filter_params(params))
          .tap { _1.sorts = "#{field} asc" }
          .result(distinct: true)
          .preload(entity.includes)
          .accessible_by(ability)
          .limit(LIMIT)
          .pluck(entity.find_field_by_name(field).to_sql)
      end
    end
  end
end
