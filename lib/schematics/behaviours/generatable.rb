# frozen_string_literal: true

module Schematics
  module Behaviours
    module Generatable
      def to_openai_schema = {
        type.to_sym => {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: openai_description,
              enum: [type]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              additionalProperties: false,
              anyOf: available_options
                .reject(&:hidden?)
                .map(&:option_name)
                .map { { '$ref': "#/$defs/#{it}" } }
            }
          }
        }
      }
    end
  end
end
