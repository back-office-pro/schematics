# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Tokens
    # :reek:InstanceVariableAssumption
    class Boolean < Token
      REGEX = /(true|false)/
      PRECEDENCE = 8

      def to_sql = @value.upcase
    end
  end
end
