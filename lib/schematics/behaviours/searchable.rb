# frozen_string_literal: true

module Schematics
  module Behaviours
    module Searchable
      def search_column = name.to_sym

      def search_predicate = :i_cont

      def search_query = :"#{search_column}_#{search_predicate}"
    end
  end
end
