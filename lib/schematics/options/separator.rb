# frozen_string_literal: true

module Schematics
  module Options
    class Separator < Option
      class << self
        def input_type = :select

        def controller = 'dropdown'

        def multiple? = false

        def collection = %w[, .]

        def openai_type = 'string'

        def openai_description = 'The number decimal separator'

        def openai_enum = { enum: collection }
      end
    end
  end
end
