# frozen_string_literal: true

module Schematics
  module Searchkickable
    class AutocompleteQuery < ApplicationQuery
      include Filterable
      LIMIT = 5

      def call(params, field, ability)
        search(
          select: field,
          load: false,
          includes: entity.includes,
          where: parse_filter_params(params).except(:with_deleted),
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
    end
  end
end
