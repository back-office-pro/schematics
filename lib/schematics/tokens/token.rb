# frozen_string_literal: true

module Schematics
  module Tokens
    class Token
      attr_reader :value

      class << self
        def create((variable, operator, string, number, parenthesis, comparator, combinator, *whitespace), table_name) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Layout/LineLength
          return Variable.new(variable, table_name) if variable
          return Operator.new(operator) if operator
          return String.new(string) if string
          return Number.new(number) if number
          return Parenthesis.new(parenthesis) if parenthesis
          return Comparator.new(comparator) if comparator
          return Combinator.new(combinator) if combinator

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
