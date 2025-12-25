# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'active_support/core_ext/array/access'
require 'active_support/core_ext/string/filters'

module Schematics
  module Tokens
    # :reek:InstanceVariableAssumption
    class Function < Token
      include Behaviours::Preloadable

      REGEX = %r{((?:NOW|SUM|AVG|MIN|MAX|COUNT|ABS|ROUND|CEIL|FLOOR|SQRT)\([$\w.\s*+\-/]*\))}
      CAPTURING_REGEX = /(NOW|SUM|AVG|MIN|MAX|COUNT|ABS|ROUND|CEIL|FLOOR|SQRT)\((.*)\)/
      PRECEDENCE = 5

      def references = variables
        .flat_map(&:references)
        .uniq

      def to_sql =
        case @value
        when 'NOW()'
          'current_timestamp'
        else
          super.remove('$')
        end

      def to_str = "\#{#{value}}"

      def value =
        case @value
        when 'NOW()'
          'Time.current'
        else
          tokens
            .each_with_object(name)
            .map(&:fn_value)
            .join
        end

      private

      memoize def tokens = Tokenizer.tokenize(body)

      def variables = tokens.grep(Variable)

      def body = @value
        .scan(CAPTURING_REGEX)
        .flatten
        .second

      def name = @value
        .scan(CAPTURING_REGEX)
        .flatten
        .first
        .downcase
        .to_sym
    end
  end
end
