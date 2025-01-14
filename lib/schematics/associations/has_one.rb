# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Associations
    class HasOne < Association
      include Behaviours::Searchable

      def open_api_schema_type = super.first

      def open_api_query_type = 'string'

      def search_column = :"#{name}_#{descriptor.name}"

      protected

      def association_to_str = super
        .concat(",\n")
        .concat <<~RUBY.indent(8)
          inverse_of: :#{inverse_of},
          autosave: true
        RUBY

      def spec_interpolations = super.merge(entity_name: inverse_of)
    end
  end
end
