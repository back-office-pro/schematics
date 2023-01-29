# frozen_string_literal: true

module Schematics
  module Ransackable
    class ListQuery < ApplicationQuery
      # :reek:ControlParameter
      def call(filter_params, ability, sort_params = nil)
        left_joins(entity.joins)
          .ransack(parse_filter_params(filter_params))
          .tap { _1.sorts = parse_sort_params(sort_params) }
          .result(distinct: true)
          .preload(entity.includes)
          .accessible_by(ability)
      end

      private

      def parse_sort_params(params)
        return "#{implicit_order_column} desc" unless params

        params
          .split(',')
          .map { |param| param.start_with?('-') ? "#{param[1..]} desc" : "#{param} asc" }
      end

      def parse_filter_params(params)
        params
          .deep_flatten
          .transform_keys { entity.find_field_by_name(_1)&.search_query || _1 }
      end
    end
  end
end
