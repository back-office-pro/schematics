# frozen_string_literal: true

module Schematics
  module Behaviours
    module Searchable
      def search_column = name.to_sym

      def search_predicate = :i_cont

      def search_query = :"#{name}_#{search_predicate}"

      def search_alias = <<~RUBY
        ransack_alias :#{name}, :#{search_column}
      RUBY

      def open_api_query_type = open_api_schema_type
    end
  end
end
