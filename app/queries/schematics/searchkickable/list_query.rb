# frozen_string_literal: true

module Schematics
  module Searchkickable
    class ListQuery < ApplicationQuery
      include Sortable
      include Filterable

      # :reek:ControlParameter
      def call(filter_params, ability, sort_params = nil)
        pagy_search(
          includes: entity.includes,
          where: parse_filter_params(filter_params).except(:with_deleted),
          order: parse_sort_params(sort_params),
          scope_results: lambda do |results|
            results
              .then_tap { _1.with_deleted if filter_params.key?(:with_deleted) }
              .accessible_by(ability)
          end
        )
      end
    end
  end
end
