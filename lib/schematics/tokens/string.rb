# frozen_string_literal: true

require 'schematics/tokens/token'

module Schematics
  module Tokens
    class String < Token
      def to_sql
        "'#{super}'"
      end
    end
  end
end
