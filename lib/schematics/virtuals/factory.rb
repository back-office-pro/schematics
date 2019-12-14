module Schematics
  module Virtuals
    class Factory
      def self.create(entity, name:, function:)
        tokens = Tokens::Tokenizer.tokenize(function)
        return Virtuals::Calculation.new(entity, name, tokens) if tokens.any_is_a?(Tokens::Operator)
        return Virtuals::Reference.new(entity, name, tokens)   if tokens.any_is_a?(Tokens::Reference)
        return Virtuals::String.new(entity, name, tokens)
      end
    end
  end
end
