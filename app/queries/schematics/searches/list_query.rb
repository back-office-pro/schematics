# frozen_string_literal: true

module Schematics
  module Searches
    class ListQuery < ApplicationQuery
      # :reek:ControlParameter
      def call(filter_params, ability, sort_params = nil)
        preload_all
          .with_string_translations
          .ransack(parse_filter_params(filter_params))
          .tap { it.sorts = parse_sort_params(sort_params) }
          .result
          .references(entity.joins)
          .accessible_by(ability)
      end

      private

      def parse_filter_params(params)
        params
          .deep_flatten
          .transform_keys { entity.find_field_by_name(it)&.search_query || it }
      end

      # :reek:ControlParameter
      def parse_sort_params(params)
        params
          &.split(',')
          &.map { it.start_with?('-') ? "#{it[1..]} desc" : "#{it} asc" } ||
          "#{implicit_order_column} desc"
      end
    end
  end
end
