# frozen_string_literal: true

module Schematics
  module Tokens
    class String < Token
      REGEX = /([a-zA-Z_-]+)/
      PRECEDENCE = 9

      def to_sql = "'#{super}'"
    end
  end
end
