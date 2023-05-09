# frozen_string_literal: true

module Schematics
  module Tokens
    class Tokenizer
      REGEX = %r{
        (\s*(?:&&|\|\|)\s*)                             | # Combinator
        (\s+(?:\*\*|\+|-|\*|/|%|\||&)\s+)               | # Operator
        (\s*(?:==\s*NULL|!=\s*NULL|<=|>=|<|>|!=|==)\s*) | # Comparator
        (\s*(?:\+=|-=|\*=|=)\s*)                        | # Assignment
        (\w+\(\))                                       | # Function
        (\(|\))                                         | # Parenthesis
        \$(\w+\.?\w+\?{0,1})                            | # Variable
        (true|false)                                    | # Boolean
        ([a-zA-Z_-]+)                                   | # String
        (\d*\.?\d+)                                     | # Number
        (\s+)                                             # Whitespace
      }x

      TOKEN_CLASSES = [
        Combinator,
        Operator,
        Comparator,
        Assignment,
        Function,
        Parenthesis,
        Variable,
        Boolean,
        String,
        Number,
        Whitespace
      ].freeze

      class << self
        def tokenize(function, prefix = nil)
          function.scan(REGEX).map do |match|
            klass, value = TOKEN_CLASSES.zip(match).to_h.compact.first
            klass.new(value, prefix)
          end
        end
      end
    end
  end
end
