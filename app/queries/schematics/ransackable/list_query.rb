# frozen_string_literal: true

module Schematics
  module Ransackable
    class ListQuery < ApplicationQuery
      include Sortable
      include Filterable

      # :reek:ControlParameter
      def call(filter_params, ability, sort_params = nil)
        left_joins(entity.joins)
          .ransack(parse_filter_params(filter_params))
          .tap { _1.sorts = parse_sort_params(sort_params) }
          .result(distinct: true)
          .preload(entity.includes)
          .accessible_by(ability)
      end
    end
  end
end
