# frozen_string_literal: true

module Schematics
  module Resources
    class SearchQuery < ApplicationQuery
      def call(filter_params, ability, sort_params = nil)
        ransack(filter_params)
          .tap { _1.sorts = sort_params || "#{implicit_order_column} desc" }
          .result(distinct: true)
          .includes(entity.includes)
          .accessible_by(ability)
      end
    end
  end
end
