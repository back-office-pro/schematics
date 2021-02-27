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
        REGEX = /\$(\w+\.?\w+)|(\s\W\s)|([a-zA-Z_-]+)|(\d*\.?\d+)|(\(|\))|(\s+)/

        def tokenize(function, table_name)
          function.scan(REGEX).map do |match|
            Token.create(match, table_name)
          end
        end
      end
    end
  end
end
