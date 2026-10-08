# frozen_string_literal: true

module Schematics
  module Options
    class Option
      delegate :hidden?, :option_name, to: :class

      class << self
        def hidden? = false

        def option_name = name
          .demodulize
          .underscore
          .to_sym

        def openai_type = input_type.to_s

        def openai_enum = {}

        def to_openai_schema = {
          option_name => {
            type: 'object',
            additionalProperties: false,
            required: [option_name.to_s],
            properties: {
              option_name => {
                type: openai_type,
                description: openai_description,
                **openai_enum
              }
            }
          }
        }
      end
    end
  end
end
