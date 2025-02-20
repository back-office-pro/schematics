# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module Schematics
  module Tokens
    class Variable < Token
      include Behaviours::Preloadable

      REGEX = /\$(\w+\.?\w+\?{0,1})/
      PRECEDENCE = 7
      FN_METHODS = { avg: :average, min: :minimum, max: :maximum }.freeze

      def to_sql = [prefix, raw_value].join('.')

      def to_str = "\#{#{safe_value}_formatted}"

      def value = ['self', safe_value, @suffix]
        .compact
        .join('.')

      def raw_value = @value
        .split('.')
        .last

      def fn_value(name)
        return "#{value}&.#{name}" unless with_references?

        "#{references.first}.#{FN_METHODS.fetch(name, name)}(&:#{raw_value})"
      end

      def with_references? = references.any?

      def references = @value
        .split('.')
        .tap(&:pop)

      private

      def prefix
        return @prefix unless with_references?

        references.map(&:pluralize)
      end

      def safe_value = @value.gsub('.', '&.')
    end
  end
end
