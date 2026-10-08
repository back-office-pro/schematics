# frozen_string_literal: true

module Schematics
  module Options
    class Unit < Option
      class << self
        def input_type = :string

        def openai_description = 'The number unit'
      end
    end
  end
end
