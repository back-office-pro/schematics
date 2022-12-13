# frozen_string_literal: true

module Schematics
  module Tokens
    # :reek:InstanceVariableAssumption
    class Function < Token
      def to_str =
        case @value
        when 'CURRENT_DATE()'
          '#{Date.current}' # rubocop:disable Lint/InterpolationCheck
        when 'CURRENT_TIMESTAMP()'
          '#{Time.current}' # rubocop:disable Lint/InterpolationCheck
        else
          super
        end

      def value =
        case @value
        when 'CURRENT_DATE()'
          'Date.current'
        when 'CURRENT_TIMESTAMP()'
          'Time.current'
        else
          super
        end
    end
  end
end
