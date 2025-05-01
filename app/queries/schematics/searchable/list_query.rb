# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Searchable
    class ListQuery < ApplicationQuery
      # :reek:ControlParameter
      def call(filter_params, ability, sort_params = nil)
        preload_all
          .with_string_translations
          .ransack(parse_filter_params(filter_params))
          .tap { _1.sorts = parse_sort_params(sort_params) }
          .result
          .references(entity.joins)
          .accessible_by(ability)
      end

      private

      def parse_filter_params(params)
        params
          .deep_flatten
          .transform_keys { entity.find_field_by_name(_1)&.search_query || _1 }
      end

      # :reek:ControlParameter
      def parse_sort_params(params)
        params
          &.split(',')
          &.map { _1.start_with?('-') ? "#{_1[1..]} desc" : "#{_1} asc" } ||
          "#{implicit_order_column} desc"
      end
    end
  end
end
