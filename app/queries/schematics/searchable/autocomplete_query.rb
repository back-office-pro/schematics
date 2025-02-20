# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Searchable
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
