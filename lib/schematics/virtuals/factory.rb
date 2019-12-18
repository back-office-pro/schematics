module Schematics
  module Virtuals
    class Factory
      def self.create(entity, name:, function:, options: nil)
        tokens = Tokens::Tokenizer.tokenize(function, entity.type.pluralize)
        if tokens.any_is_a?(Tokens::Operator)
          Virtuals::Calculation.new(entity, name, tokens, options)
        else
          Virtuals::Concatenation.new(entity, name, tokens, options)
        end
      end
    end
  end
end
