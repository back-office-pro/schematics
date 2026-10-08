# frozen_string_literal: true

module Schematics
  module Options
    class Acceptance < Option
      class << self
        def input_type = :boolean

        def openai_description = 'Does the attribute must be accepted or not'
      end
    end
  end
end
