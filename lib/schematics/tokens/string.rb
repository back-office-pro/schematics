module Schematics
  module Tokens
    class String < Token
      def to_sql
        "'#{super}'"
      end
    end      
  end
end
