module Schematics
  module Tokens
    class Token
      attr_accessor :value

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
