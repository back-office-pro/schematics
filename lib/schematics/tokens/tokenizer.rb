module Schematics
  module Tokens
    class Tokenizer
      class << self
        REGEX = /\$(\w+\.?\w+)|(\s\W\s)|([a-zA-Z_-]+)|(\d*\.?\d+)|(\(|\))|(\s+)/.freeze

        def tokenize(function, table_name)
          tokens = []
          function.scan(REGEX).map do |match|
            if !match[0].nil? && !match[0].include?(".")
              tokens << Variable.new(match[0], table_name)
            end
            if !match[0].nil? && match[0].include?(".")
              tokens << Reference.new(match[0])
            end
            tokens << Operator.new(match[1])    unless match[1].nil?
            tokens << String.new(match[2])      unless match[2].nil?
            tokens << Number.new(match[3])      unless match[3].nil?
            tokens << Parenthesis.new(match[4]) unless match[4].nil?
            tokens << Whitespace.new            unless match[5].nil?
          end
          tokens
        end
      end
    end
  end
end
