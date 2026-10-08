# frozen_string_literal: true

module Schematics
  module Options
    class GreaterThanOrEqualTo < CollectionOption
      class << self
        def input_type = :number

        def min = nil

        def openai_description = 'The number should be greater than or equal to'
      end
    end
  end
end
