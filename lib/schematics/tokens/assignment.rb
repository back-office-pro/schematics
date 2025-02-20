# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Tokens
    class Assignment < Token
      REGEX = /(\s*(?:\+=|-=|\*=|=)\s*)/
      PRECEDENCE = 4
    end
  end
end
