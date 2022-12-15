# frozen_string_literal: true

module Schematics
  module Tokens
    class Comparator < Token
      def to_sql =
        case @value.delete(' ')
        when '==NULL' then ' IS NULL'
        when '!=NULL' then ' IS NOT NULL'
        when '==' then ' = '
        else
          super
        end

      def value =
        case @value.delete(' ')
        when '==NULL' then ' == nil '
        when '!=NULL' then ' != nil '
        else
          super
        end
    end
  end
end
