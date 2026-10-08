# frozen_string_literal: true

module Schematics
  module Options
    class Readonly < Option
      class << self
        def input_type = :boolean

        def openai_description = 'Is the attribute readonly or not'
      end
    end
  end
end
