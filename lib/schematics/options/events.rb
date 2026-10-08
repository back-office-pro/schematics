# frozen_string_literal: true

module Schematics
  module Options
    class Events < Option
      class << self
        def input_type = :events

        def openai_type = 'array'

        def openai_description = 'State machine events'

        def to_openai_schema = super.deep_merge(
          events: {
            properties: {
              events: {
                items: {
                  type: 'object',
                  properties: {
                    name: { '$ref': '#/$defs/name' },
                    icon: { '$ref': '#/$defs/icon' },
                    color: {
                      type: 'string',
                      description: 'The event style',
                      enum: StateMachineEvent::COLORS.map(&:to_s)
                    },
                    confirm: {
                      type: 'boolean',
                      description: 'Does the event action need to be confirmed'
                    },
                    from: {
                      type: 'string',
                      description: 'The starting value of the event transition'
                    },
                    to: {
                      type: 'string',
                      description: 'The ending value of the event transition'
                    }
                  },
                  additionalProperties: false,
                  required: %w[name icon color confirm from to]
                }
              }
            }
          }
        )
      end
    end
  end
end
