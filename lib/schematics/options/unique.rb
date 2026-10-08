# frozen_string_literal: true

module Schematics
  module Options
    class Unique < Option
      class << self
        def input_type = :boolean

        def openai_description = 'Is the text unique or not'
      end
    end
  end
end
