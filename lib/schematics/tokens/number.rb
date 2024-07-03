# frozen_string_literal: true

module Schematics
  module Tokens
    class Number < Token
      REGEX = /(-?\d*\.?\d+)/
      PRECEDENCE = 9
    end
  end
end
