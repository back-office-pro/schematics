# frozen_string_literal: true

module Schematics
  module Tokens
    # :reek:InstanceVariableAssumption
    class Operator < Token
      REGEX = %r{(\s+(?:\+|-|\*|/|%|\||&|<<|>>)\s+)}
      PRECEDENCE = 2
    end
  end
end
