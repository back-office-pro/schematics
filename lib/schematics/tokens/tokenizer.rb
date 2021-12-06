# frozen_string_literal: true

module Schematics
  module Tokens
    class Tokenizer
      class << self
        REGEX = %r{
          (\s*(?:&&|\|\|)\s*)               | # combinator
          (\s+(?:\*\*|\+|-|\*|/|%|\||&)\s+) | # operator
          (\s*(?:<=|>=|<|>|!=|==)\s*)       | # comparator
          (\(|\))                           | # parenthesis
          \$(\w+\.?\w+)                     | # variable
          ([a-zA-Z_-]+)                     | # string
          (\d*\.?\d+)                       | # number
          (\s+)                               # whitespace
        }x

        def tokenize(function, table_name)
          function.scan(REGEX).map do |match|
            Token.build(match, table_name)
          end
        end
      end
    end
  end
end
