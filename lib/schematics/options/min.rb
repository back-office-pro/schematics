# frozen_string_literal: true

module Schematics
  module Options
    class Min < Option
      class << self
        def input_type = :number

        def min = 0

        def openai_description = 'The minimum length of the text'
      end
    end
  end
end
