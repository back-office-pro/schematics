# frozen_string_literal: true

module Schematics
  module Options
    class Required < Option
      class << self
        def input_type = :boolean

        def openai_description = 'Is the attribute required or not'
      end
    end
  end
end
