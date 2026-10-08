# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/module/introspection'

module Schematics
  module Tokens
    module Tokenizer
      module_function

      def tokenize(function, prefix = nil, suffix = nil)
        function.scan(parser).map do |match|
          klass, value = token_classes.zip(match).to_h.compact.first
          klass.new(value, prefix, suffix)
        end
      end

      def parser = Regexp.union(token_classes.map { it::REGEX })

      def token_classes = module_parent
        .constants
        .map(&module_parent.method(:const_get))
        .excluding(self, Token)
        .sort_by { it::PRECEDENCE }
    end
  end
end
