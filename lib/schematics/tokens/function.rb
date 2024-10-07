# frozen_string_literal: true

module Schematics
  module Tokens
    # :reek:InstanceVariableAssumption
    class Function < Token
      include Behaviours::Preloadable

      REGEX = /((?:NOW|RAND|SUM|AVG|MIN|MAX|COUNT|ABS|ROUND|CEIL|FLOOR)\((?:\$\w+\.?\w+\?{0,1})?\))/
      PRECEDENCE = 5
      METHODS = {
        COUNT: :count,
        SUM: :sum,
        AVG: :average,
        MIN: :minimum,
        MAX: :maximum
      }.freeze

      delegate :references, to: :variable, allow_nil: true
      delegate :raw_value,
               :value,
               to: :variable,
               prefix: true,
               allow_nil: true,
               private: true

      def to_sql = super.tr('$', '')

      def to_str = "\#{#{value}}"

      def value =
        case @value
        in 'NOW()'
          'Time.current'
        in 'RAND()'
          'rand'
        in /(SUM|COUNT|AVG|MIN|MAX).*/
          if references.empty?
            "#{variable_value}.#{Regexp.last_match(1).downcase}"
          else
            "#{references.first}.#{METHODS[Regexp.last_match(1).to_sym]}(&:#{variable_raw_value})"
          end
        in /(ABS|ROUND|CEIL|FLOOR).*/
          "#{variable_value}.#{Regexp.last_match(1).downcase}"
        else
          super
        end

      private

      memoize def variable
        Variable.new(@value[Variable::REGEX, 1]) if @value[Variable::REGEX, 1]
      end
    end
  end
end
