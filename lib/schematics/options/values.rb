# frozen_string_literal: true

module Schematics
  module Options
    class Values < Option
      class << self
        def input_type = :array

        def openai_description = 'The enumeration values'

        def openai_enum = { items: { type: 'string' } }
      end
    end
  end
end
