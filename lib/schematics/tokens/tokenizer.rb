module Schematics
  module Tokens
    class Tokenizer
      class << self
        REGEX = /\$(\w+\.?\w+)|(\s\W\s)|([a-zA-Z_-]+)|(\d*\.?\d+)|(\(|\))|(\s+)/.freeze

        def tokenize(function, table_name)
          function.scan(REGEX).map do |match|
            Token.create(match, table_name)
          end
        end
      end
    end
  end
end
