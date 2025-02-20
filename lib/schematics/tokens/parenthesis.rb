# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Tokens
    class Parenthesis < Token
      REGEX = /(\(|\))/
      PRECEDENCE = 6
    end
  end
end
