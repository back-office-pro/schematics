# frozen_string_literal: true

module Schematics
  module Ransackable
    class ListQuery < ApplicationQuery
      include Sortable
      include Filterable

      # :reek:ControlParameter
      def call(filter_params, ability, sort_params = nil)
        ransack(parse_filter_params(filter_params))
          .tap { _1.sorts = parse_sort_params(sort_params) }
          .result(distinct: true)
          .select("#{table_name}.*, #{virtual_database_fields}")
          .left_joins(entity.joins)
          .preload(entity.includes)
          .accessible_by(ability)
      end

      protected

      def virtual_database_fields = entity
        .virtuals
        .map(&:to_sql)
        .join(',')
    end
  end
end
