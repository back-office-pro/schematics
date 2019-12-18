module Schematics
  module Tokens
    class Variable < Token
      def initialize(value, table_name)
        super(value)
        @table_name = table_name
      end

      def to_sql
        [@table_name, @value].join('.')
      end

      def to_str
        "#\{#{@value}}"
      end
    end
  end
end
