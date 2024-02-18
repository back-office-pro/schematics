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

      def search_data = <<~RUBY.squish
        #{name}:
      RUBY

      def open_api_filter_type
        case open_api_type
        when Hash
          open_api_type.values.first
        when Array
          open_api_type.first
        else
          open_api_type
        end
      end
    end
  end
end
