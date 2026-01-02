# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Tokens
    # :reek:InstanceVariableAssumption
    class Comparator < Token
      REGEX = /(\s*(?:==\s*NULL|!=\s*NULL|<=|>=|<|>|!=|==)\s*)/
      PRECEDENCE = 3

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
