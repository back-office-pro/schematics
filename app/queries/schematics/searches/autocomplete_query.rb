# frozen_string_literal: true

module Schematics
  module Searches
    class AutocompleteQuery < ListQuery
      LIMIT = 5

      def call(params, ability, field)
        super
          .limit(LIMIT)
          .map(&field.to_sym)
          .map(&:to_s)
          .uniq
      end
    end
  end
end
