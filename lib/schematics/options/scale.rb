# frozen_string_literal: true

module Schematics
  module Options
    class Scale < Option
      class << self
        def input_type = :number

        def min = 0

        def openai_description = 'The number of digits following the decimal point in the number'
      end
    end
  end
end
