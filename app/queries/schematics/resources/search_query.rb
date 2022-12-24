# frozen_string_literal: true

module Schematics
  module Resources
    class SearchQuery < ApplicationQuery
      # :reek:ControlParameter
      def call(filter_params, ability, sort_params = nil)
        left_joins(entity.joins)
          .ransack(filter_params)
          .tap { _1.sorts = sort_params || "#{implicit_order_column} desc" }
          .result(distinct: true)
          .preload(entity.includes)
          .accessible_by(ability)
      end
    end
  end
end
