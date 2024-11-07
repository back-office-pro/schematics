# frozen_string_literal: true

module Schematics
  module Searchable
    class MultisearchQuery < ListQuery
      def call(param, ability)
        super({ entity.multisearch_query => param }, ability)
      end
    end
  end
end
