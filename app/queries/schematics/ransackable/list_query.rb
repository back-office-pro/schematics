# frozen_string_literal: true

module Schematics
  module Ransackable
    class ListQuery < ApplicationQuery
      include Sortable
      include Filterable

      # :reek:ControlParameter
      def call(filter_params, ability, sort_params = nil)
        preload_all
          .ransack(parse_filter_params(filter_params))
          .tap { _1.sorts = parse_sort_params(sort_params) }
          .result(distinct: true)
          .select(arel_table[::Arel.star], *entity.virtuals.map(&:to_sql))
          .left_joins(entity.joins)
          .accessible_by(ability)
          .load_async
      end
    end
  end
end
