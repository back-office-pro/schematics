# frozen_string_literal: true

module Schematics
  module Options
    class Schemes < Option
      class << self
        def input_type = :select

        def controller = 'dropdown'

        def multiple? = true

        def collection = %w[http https]

        def openai_type = 'array'

        def openai_description = 'The URL schemes'

        def openai_enum = { items: { type: 'string', enum: collection } }
      end
    end
  end
end
