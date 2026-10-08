# frozen_string_literal: true

module Schematics
  module Tokens
    class Token
      attr_reader :value

      def initialize(value, prefix = nil, suffix = nil)
        @value = value
        @prefix = prefix
        @suffix = suffix
      end

      def fn_value(*) = @value

      def to_sql = @value

      def to_str = @value
    end
  end
end
