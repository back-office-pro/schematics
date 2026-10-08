# frozen_string_literal: true

module Schematics
  module Options
    class EndDate < Option
      class << self
        def input_type = :boolean

        def openai_description = 'Is the date the end of a calendar range'
      end
    end
  end
end
