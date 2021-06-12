# frozen_string_literal: true

require 'schematics/tokens/token'

module Schematics
  module Tokens
    class Comparator < Token
      def to_str
        case value.strip
        when '<>' then ' != '
        else
          super
        end
      end

      def to_sql
        case value.strip
        when '==' then ' = '
        else
          super
        end
      end
    end
  end
end
