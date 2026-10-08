# frozen_string_literal: true

module Schematics
  module Options
    class OtherThan < CollectionOption
      class << self
        def input_type = :number

        def min = nil

        def openai_description = 'The number should be other than'
      end
    end
  end
end
