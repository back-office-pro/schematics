# frozen_string_literal: true

module Schematics
  module Tokens
    # :reek:InstanceVariableAssumption
    class Function < Token
      include Behaviours::Preloadable

      REGEX = %r{((?:NOW|RAND|SUM|AVG|MIN|MAX|COUNT|ABS|ROUND|CEIL|FLOOR)\([\$\w\.\s\*\+\-/]*\))}
      VARIABLE_REGEX = /(SUM|COUNT|AVG|MIN|MAX|ABS|ROUND|CEIL|FLOOR)\(#{Variable::REGEX}\)/
      OPERATOR_REGEX = /
        (SUM|COUNT|AVG|MIN|MAX)\(
          #{Variable::REGEX}
          #{Operator::REGEX}
          #{Variable::REGEX}
        \)
      /x
      PRECEDENCE = 5
      METHODS = {
        COUNT: :count,
        SUM: :sum,
        AVG: :average,
        MIN: :minimum,
        MAX: :maximum
      }.freeze

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
        in OPERATOR_REGEX
          variables
            .map { __send__(call, _1, Regexp.last_match(1)) }
            .insert(1, Regexp.last_match(3))
            .join
        in VARIABLE_REGEX
          __send__(call, variables.first, Regexp.last_match(1))
        else
          super
        end

      private

      def call
        return :method_call if references.empty?

        :parameterized_method_call
      end

      def parameterized_method_call(variable, method)
        "#{variable.references.first}.#{METHODS[method.to_sym]}(&:#{variable.raw_value})"
      end

      def method_call(variable, method)
        "#{variable.value}.#{method.downcase}"
      end

      memoize def variables = @value
        .scan(Variable::REGEX)
        .flatten
        .map(&Variable.method(:new))
    end
  end
end
