# frozen_string_literal: true

module Schematics
  module Ransackable
    class AutocompleteQuery < ListQuery
      LIMIT = 5

      def call(params, ability, field)
        super
          .limit(LIMIT)
          .pluck(entity.find_field_by_name(field).to_sql)
      end
    end
  end
end
