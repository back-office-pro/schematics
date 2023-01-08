# frozen_string_literal: true

module Schematics
  module Searchkickable
    class SearchListQuery < ApplicationQuery
      # :reek:ControlParameter
      def call(filter_params, ability, sort_params = nil)
        filter_params = parse_filter_params(filter_params)
        pagy_search(
          includes: entity.includes,
          where: filter_params.except(:with_deleted),
          order: parse_sort_params(sort_params),
          scope_results: lambda { |results|
            results
              .then_tap { _1.with_deleted if filter_params.key?(:with_deleted) }
              .accessible_by(ability)
          }
        )
      end

      private

      def parse_sort_params(params)
        unless params
          return { implicit_order_column.to_sym => { order: :desc, unmapped_type: 'long' } }
        end

        ordering = {}
        sort_order = { '+': :asc, '-': :desc }
        params
          .split(',')
          .each do |param|
            sort_sign = param.match?(/\A[+-]/) ? param.slice!(0) : '+'
            ordering[param] = { order: sort_order[sort_sign.to_sym] }
          end
        ordering
      end

      def parse_filter_params(params)
        params.transform_values(&method(:cast_filter_value))
      end

      def cast_comparison(value)
        return value.to_date if value.match?(/\d{4}-\d{2}-\d{2}/)

        value.to_f
      end

      def cast_filter_value(value)
        case value
        in 'true'
          true
        in 'false'
          false
        in gte:
          { gte: cast_comparison(gte) }
        in lte:
          { lte: cast_comparison(lte) }
        else
          { ilike: "%#{value}%" }
        end
      end
    end
  end
end
