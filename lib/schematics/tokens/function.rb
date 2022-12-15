# frozen_string_literal: true

module Schematics
  module Tokens
    # :reek:InstanceVariableAssumption
    class Function < Token
      def to_str =
        case @value
        when 'NOW()'
          '#{Time.current}' # rubocop:disable Lint/InterpolationCheck
        else
          super
        end

      def value =
        case @value
        when 'NOW()'
          'Time.current'
        else
          super
        end
    end
  end
end
