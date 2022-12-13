# frozen_string_literal: true

module Schematics
  module Tokens
    # :reek:InstanceVariableAssumption
    class Function < Token
      def value = case @value
                  when 'NOW()'
                    'Time.current'
                  end
    end
  end
end
