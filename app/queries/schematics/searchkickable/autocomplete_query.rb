# frozen_string_literal: true

module Schematics
  module Searchkickable
    class AutocompleteQuery < ApplicationQuery
      include Filterable
      LIMIT = 5

      def call(params, ability, field)
        search(
          select: field.to_sym,
          load: false,
          includes: entity.includes,
          where: parse_filter_params(params).except(:with_deleted),
          order: { field.to_sym => { order: :asc } },
          scope_results: lambda do |results|
            results
              .then_tap { _1.with_deleted if params.key?(:with_deleted) }
              .accessible_by(ability)
          end
        ).limit(LIMIT)
          .map(&field.to_sym)
          .map(&:to_s)
          .uniq
      end
    end
  end
end
