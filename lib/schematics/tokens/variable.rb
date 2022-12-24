# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module Schematics
  module Tokens
    class Variable < Token
      def initialize(value, table_name)
        super(value)
        @table_name = table_name
      end

      def to_sql = [prefix, raw_value].join('.')

      def to_str = '#{' + @value + '_formatted}' # rubocop:disable Style/StringConcatenation

      def value = "self.#{@value}"

      def raw_value = @value
        .split('.')
        .last

      def with_references? = references.any?

      def references = @value
        .split('.')
        .tap(&:pop)

      private

      def prefix
        return @table_name unless with_references?

        references.map(&:pluralize)
      end
    end
  end
end
