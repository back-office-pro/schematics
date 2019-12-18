module Schematics
  module Tokens
    class Tokenizer
      REGEX = /\$(\w+\.?\w+)|(\s\W\s)|([a-zA-Z_-]+)|(\d*\.?\d+)|(\(|\))|(\s+)/

      def self.tokenize(function, table_name)
        tokens = []
        function.scan(REGEX).map do |match|
          tokens << Tokens::Variable.new(match[0], table_name)  if !match[0].nil? && !match[0].include?(".")
          tokens << Tokens::Reference.new(match[0])             if !match[0].nil? && match[0].include?(".")
          tokens << Tokens::Operator.new(match[1])              unless match[1].nil?
          tokens << Tokens::String.new(match[2])                unless match[2].nil?
          tokens << Tokens::Number.new(match[3])                unless match[3].nil?
          tokens << Tokens::Parenthesis.new(match[4])           unless match[4].nil?
          tokens << Tokens::Whitespace.new                      unless match[5].nil?
        end
        tokens
      end
    end
  end
end
