# frozen_string_literal: true

module Schematics
  module Options
    class Length < Option
      class << self
        def input_type = :number

        def min = 0

        def openai_description = 'The exact length of the text'
      end
    end
  end
end
