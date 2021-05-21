# frozen_string_literal: true

require 'schematics/tokens/token'

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
          @value.split('.').last,
        ].join('.')
      end

      def to_str
        '#{' + @value + '}' # rubocop:disable Style/StringConcatenation
      end

      def references
        @value.split('.').tap(&:pop)
      end
    end
  end
end
