# frozen_string_literal: true

module Schematics
  module Tokens
    # :reek:InstanceVariableAssumption
    class Function < Token
      REGEX = /(NOW\(\)|RAND\(\))/
      PRECEDENCE = 5

      def to_str =
        case @value
        when 'NOW()'
          '#{Time.current}' # rubocop:disable Lint/InterpolationCheck
        when 'RAND()'
          '#{rand}' # rubocop:disable Lint/InterpolationCheck
        else
          super
        end

      def value =
        case @value
        when 'NOW()'
          'Time.current'
        when 'RAND()'
          'rand'
        else
          super
        end
    end
  end
end
