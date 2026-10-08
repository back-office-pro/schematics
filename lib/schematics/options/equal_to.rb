# frozen_string_literal: true

module Schematics
  module Options
    class EqualTo < CollectionOption
      class << self
        def input_type = :number

        def min = nil

        def openai_description = 'The number should be equal to'
      end
    end
  end
end
