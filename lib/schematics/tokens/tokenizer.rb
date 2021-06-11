# frozen_string_literal: true

require 'schematics/tokens/combinator'
require 'schematics/tokens/comparator'
require 'schematics/tokens/number'
require 'schematics/tokens/operator'
require 'schematics/tokens/parenthesis'
require 'schematics/tokens/string'
require 'schematics/tokens/token'
require 'schematics/tokens/variable'
require 'schematics/tokens/whitespace'

module Schematics
  module Tokens
    class Tokenizer
      class << self
        REGEX = %r{
          \$(\w+\.?\w+) |                   # variable
          (\s(?:-|\+|\*|/)\s) |             # operator
          ([a-zA-Z_-]+) |                   # string
          (\d*\.?\d+) |                     # number
          (\(|\)) |                         # parenthesis
          (\s*(?:<=|>=|<|>|!=|<>|==)\s*) |  # comparator
          (\s*(?:&&|\|\|)\s*) |             # combinator
          (\s+)                             # whitespace
        }x

        def tokenize(function, table_name)
          function.scan(REGEX).map do |match|
            Token.create(match, table_name)
          end
        end
      end
    end
  end
end
