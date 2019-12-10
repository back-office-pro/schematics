module Schematics
  module Tokens
    class Variable < Token
      def concatenated_value
        value
      end
      
      def parsed_value
        "#\{#{@value}}"
      end
    end
  end
end
