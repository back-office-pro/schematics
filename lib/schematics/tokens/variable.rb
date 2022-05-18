# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module Schematics
  module Tokens
    class Variable < Token
      def initialize(value, table_name)
        super(value)
        @table_name = table_name
      end

      def to_sql
        [
          references.any? ? references.map(&:pluralize) : @table_name,
          @value.split('.').last
        ].join('.')
      end

      def to_str
        '#{' + @value + '_formatted}' # rubocop:disable Style/StringConcatenation
      end

      def value
        "self.#{@value}"
      end

      def references = @value
        .split('.')
        .tap(&:pop)
    end
  end
end
