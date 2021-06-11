# frozen_string_literal: true

require 'schematics/tokens/token'

module Schematics
  module Tokens
    class Combinator < Token
      def to_sql
        case value.strip
        when '&&' then ' AND '
        when '||' then ' OR '
        else
          super
        end
      end
    end
  end
end
