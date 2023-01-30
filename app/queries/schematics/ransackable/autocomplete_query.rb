# frozen_string_literal: true

module Schematics
  module Ransackable
    class AutocompleteQuery < ListQuery
      LIMIT = 5

      def call(params, ability, field)
        super
          .limit(LIMIT)
          .map(&field.to_sym)
          .map(&:to_s)
      end
    end
  end
end
