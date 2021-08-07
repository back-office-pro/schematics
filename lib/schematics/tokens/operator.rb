# frozen_string_literal: true

module Schematics
  module Tokens
    class Operator < Token
      def to_sql
        case value.strip
        when '**' then ' ^ '
        else
          super
        end
      end
    end
  end
end
