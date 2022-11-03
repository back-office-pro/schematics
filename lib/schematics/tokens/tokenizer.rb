# frozen_string_literal: true

module Schematics
  module Tokens
    class Tokenizer
      REGEX = %r{
        (\s*(?:&&|\|\|)\s*)               | # combinator
        (\s+(?:\*\*|\+|-|\*|/|%|\||&)\s+) | # operator
        (\s*(?:<=|>=|<|>|!=|==)\s*)       | # comparator
        (\s*(?:\+=|-=|\*=|=)\s*)          | # assignment
        (\(|\))                           | # parenthesis
        \$(\w+\.?\w+\?{0,1})              | # variable
        ([a-zA-Z_-]+)                     | # string
        (\d*\.?\d+)                       | # number
        (\s+)                               # whitespace
      }x

      class << self
        def tokenize(function, table_name = nil)
          function.scan(REGEX).map do |match|
            Token.build(match, table_name)
          end
        end
      end
    end
  end
end
