# frozen_string_literal: true

module Schematics
  module Options
    class Width < Option
      class << self
        def input_type = :number

        def min = 0

        def openai_description = 'The width of the image in pixels'
      end
    end
  end
end
