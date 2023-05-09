# frozen_string_literal: true

module Schematics
  module Tokens
    # :reek:InstanceVariableAssumption
    class Operator < Token
      REGEX = %r{(\s+(?:\*\*|\+|-|\*|/|%|\||&)\s+)}
      PRECEDENCE = 2

      def to_sql =
        case @value.strip
        when '**' then ' ^ '
        else
          super
        end
    end
  end
end
