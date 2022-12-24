# frozen_string_literal: true

module Schematics
  module Resources
    class AutocompleteQuery < ApplicationQuery
      LIMIT = 5

      def call(params, field, ability)
        left_joins(entity.joins)
          .ransack(params)
          .result(distinct: true)
          .preload(entity.includes)
          .accessible_by(ability)
          .limit(LIMIT)
          .pluck(entity.find_field_by_name(field).to_sql)
      end
    end
  end
end
