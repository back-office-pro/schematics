# frozen_string_literal: true

module Schematics
  module Tokens
    # :reek:SubclassedFromCoreClass
    class Whitespace < String
      def initialize
        super(' ')
      end
    end
  end
end
