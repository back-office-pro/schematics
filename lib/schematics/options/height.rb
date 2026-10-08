# frozen_string_literal: true

module Schematics
  module Options
    class Height < Option
      class << self
        def input_type = :number

        def min = 0

        def openai_description = 'The height of the image in pixels'
      end
    end
  end
end
