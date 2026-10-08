# frozen_string_literal: true

module Schematics
  module Options
    class CaseInsensitive < Option
      class << self
        def input_type = :boolean

        def openai_description = 'Is the string case insensitive or not'
      end
    end
  end
end
