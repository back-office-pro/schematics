# frozen_string_literal: true

module Schematics
  module Searchkickable
    class MultisearchQuery < ApplicationQuery
      def call(param, ability)
        search(
          param,
          includes: entity.includes,
          match: :word_middle,
          suggest: true,
          misspellings: false,
          scope_results: -> { _1.accessible_by(ability) }
        )
      end
    end
  end
end
