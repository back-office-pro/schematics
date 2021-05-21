# frozen_string_literal: true

module Schematics
  module Tokens
    class Token
      attr_reader :value

      class << self
        def create((variable, operator, string, number, parenthesis, *whitespace), table_name)
          return Variable.new(variable, table_name) if variable.present?
          return Operator.new(operator) if operator.present?
          return String.new(string) if string.present?
          return Number.new(number) if number.present?
          return Parenthesis.new(parenthesis) if parenthesis.present?

          Whitespace.new if whitespace.present?
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
