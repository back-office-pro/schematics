# frozen_string_literal: true

module Schematics
  module Options
    class AspectRatio < Option
      class << self
        def input_type = :select

        # rubocop:disable Naming/VariableNumber
        def collection = %i[
          landspace
          square
          is_16_9
          is_4_3
        ]
        # rubocop:enable Naming/VariableNumber
      end
    end
  end
end
