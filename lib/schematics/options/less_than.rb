# frozen_string_literal: true

module Schematics
  module Options
    class LessThan < CollectionOption
      class << self
        def input_type = :number

        def min = nil

        def openai_description = 'The number should be less than'
      end
    end
  end
end
