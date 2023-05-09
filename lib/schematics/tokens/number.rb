# frozen_string_literal: true

module Schematics
  module Tokens
    class Number < Token
      REGEX = /(\d*\.?\d+)/
      PRECEDENCE = 10
    end
  end
end
