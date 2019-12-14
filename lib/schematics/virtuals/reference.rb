module Schematics
  module Virtuals
    class Reference < Virtual
      def parse
        "\"#{super}\""
      end

      def concat
        @tokens.map do |token| 
          token.is_a?(Tokens::Variable) ? "#{@entity.type.pluralize}.#{token.concatenated_value}" : token.concatenated_value
        end.join(", ")
      end

      def joins
        @tokens.select_is_a?(Tokens::Reference).map do |reference| 
          variables = reference.value.split('.')
          variables[0...-1].map { |variable| ":#{variable}" }
        end.flatten.uniq.join(', ')
      end

      def scope
        super + %Q[#{@name} { joins(#{joins}).where("CONCAT(#{concat}) ILIKE ?", "%#\{#{@name}}%") }]
      end

      def searchable?
        true
      end
    end
  end
end
