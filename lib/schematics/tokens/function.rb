# frozen_string_literal: true

require 'active_support/core_ext/array/access'

module Schematics
  module Tokens
    # :reek:InstanceVariableAssumption
    class Function < Token
      include Behaviours::Preloadable

      REGEX = %r{((?:NOW|RAND|SUM|AVG|MIN|MAX|COUNT|ABS|ROUND|CEIL|FLOOR)\([\$\w\.\s\*\+\-/]*\))}
      CAPTURING_REGEX = /(NOW|RAND|SUM|AVG|MIN|MAX|COUNT|ABS|ROUND|CEIL|FLOOR)\((.*)\)/
      PRECEDENCE = 5

      def references = variables
        .flat_map(&:references)
        .uniq

      def to_sql = super.tr('$', '')

      def to_str = "\#{#{value}}"

      def value =
        case @value
        in 'NOW()'
          'Time.current'
        in 'RAND()'
          'rand'
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
