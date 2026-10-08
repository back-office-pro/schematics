# frozen_string_literal: true

module Schematics
  module Options
    class StartDate < Option
      class << self
        def input_type = :boolean

        def openai_description = 'Is the date the start of a calendar range'
      end
    end
  end
end
