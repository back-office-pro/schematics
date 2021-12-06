# frozen_string_literal: true

module Schematics
  module Tokens
    class Token
      attr_reader :value

      class << self
        # :reek:LongParameterList
        def build((combinator, operator, comparator, parenthesis, variable, string, number, *whitespace), table_name) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Layout/LineLength
          return Combinator.new(combinator) if combinator
          return Operator.new(operator) if operator
          return Comparator.new(comparator) if comparator
          return Parenthesis.new(parenthesis) if parenthesis
          return Variable.new(variable, table_name) if variable
          return String.new(string) if string
          return Number.new(number) if number

          Whitespace.new if whitespace
        end
      end

      def initialize(value)
        @value = value
      end

      def to_sql
        @value
      end

      def to_str
        @value
      end
    end
  end
end
