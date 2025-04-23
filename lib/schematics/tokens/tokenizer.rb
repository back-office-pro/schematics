# Copyright © 2025 Dev & Software. All rights reserved.
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

      def parser = Regexp.union(token_classes.map { _1::REGEX })

      def token_classes = module_parent
        .constants
        .map(&module_parent.method(:const_get))
        .excluding(self, Token)
        .sort_by { _1::PRECEDENCE }
    end
  end
end
