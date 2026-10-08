# frozen_string_literal: true

module Schematics
  module Options
    class Translated < Option
      class << self
        def input_type = :boolean

        def openai_description = 'Is the text translated or not'
      end
    end
  end
end
