# frozen_string_literal: true

module Schematics
  module Options
    class Limit < Option
      class << self
        def input_type = :number

        def min = 0

        def openai_description = 'The maximum length of the text'
      end
    end
  end
end
