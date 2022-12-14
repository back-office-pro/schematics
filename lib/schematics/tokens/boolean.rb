# frozen_string_literal: true

module Schematics
  module Tokens
    class Boolean < Token
      def to_sql = @value.upcase
    end
  end
end
