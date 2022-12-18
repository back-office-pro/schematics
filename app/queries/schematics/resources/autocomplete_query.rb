# frozen_string_literal: true

module Schematics
  module Resources
    class AutocompleteQuery < ApplicationQuery
      LIMIT = 5

      def call(params, field, ability)
        ransack(params)
          .result(distinct: true)
          .preload(entity.includes)
          .accessible_by(ability)
          .limit(LIMIT)
          .map(&field.to_sym)
      end
    end
  end
end
