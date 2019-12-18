module Schematics
  module Tokens
    class Whitespace < Token
      def initialize
        super(" ")
      end
      
      def to_sql
        "' '"
      end
    end
  end
end
