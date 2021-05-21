# frozen_string_literal: true

require 'schematics/tokens/string'

module Schematics
  module Tokens
    class Whitespace < String
      def initialize
        super(' ')
      end
    end
  end
end
