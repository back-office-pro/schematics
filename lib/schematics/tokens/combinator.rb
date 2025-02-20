# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Tokens
    # :reek:InstanceVariableAssumption
    class Combinator < Token
      REGEX = /(\s*(?:&&|\|\|)\s*)/
      PRECEDENCE = 1

      def to_sql =
        case @value.strip
        when '&&' then ' AND '
        when '||' then ' OR '
        else
          super
        end
    end
  end
end
