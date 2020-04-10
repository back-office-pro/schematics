module Schematics
  module Tokens
    class Reference < Token
      def to_sql
        [
          @value.split(".")[0...-1].map { |variable| variable.pluralize },
          @value.split(".").last,
        ].join(".")
      end

      def to_str
        "#\{#{@value}}"
      end
    end
  end
end
