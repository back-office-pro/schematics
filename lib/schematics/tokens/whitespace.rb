# frozen_string_literal: true

module Schematics
  module Tokens
    # :reek:SubclassedFromCoreClass
    class Whitespace < String
      REGEX = /(\s+)/
      PRECEDENCE = 11

      def initialize(*)
        super(' ')
      end
    end
  end
end
