# frozen_string_literal: true

module Schematics
  module Tokens
    class String < Token
      def to_sql
        "'#{super}'"
      end
    end
  end
end
