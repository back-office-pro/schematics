module Schematics
  module Tokens
    class Token
      attr_accessor :value
      
      def initialize(value)
        @value = value
      end

      def concatenated_value
        "'#{@value}'"
      end

      def parsed_value
        @value
      end
    end
  end
end
