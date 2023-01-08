# frozen_string_literal: true

module Schematics
  module Searchkickable
    class AutocompleteQuery < ApplicationQuery
      LIMIT = 5

      def call(params, field, ability)
        params = parse_params(params)
        search(
          select: field,
          load: false,
          includes: entity.includes,
          where: params.except(:with_deleted),
          order: { field.to_sym => { order: :asc } },
          scope_results: lambda { |results|
            results
              .then_tap { _1.with_deleted if params.key?(:with_deleted) }
              .accessible_by(ability)
          }
        ).limit(LIMIT)
          .map(&field)
          .map(&:to_s)
          .uniq
      end

      private

      def parse_params(params)
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
