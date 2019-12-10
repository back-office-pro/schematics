module Schematics
  module Tokens
    class Reference < Token
      def concatenated_value
        [@value.split(".")[0...-1].map { |variable| variable.pluralize }, @value.split(".").last].join(".")
      end

      def parsed_value
        "#\{#{@value}}"
      end
    end
  end
end
