# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Paths::Autocomplete do
  subject { described_class.new(entity:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { schema.find_entity_by_name('team') }
  let(:expected_hash) do
    {
      '/teams/autocompletions': {
        post: {
          operationId: 'Team_Autocomplete',
          parameters: [
            description: 'Inflect payload keys. Possible values are camel, dash, snake or pascal.',
            in: 'header',
            name: 'x-api-inflection',
            required: false,
            schema: {
              description: 'Inflect payload keys. Possible values are camel, dash, snake or pascal.', # rubocop:disable Layout/LineLength
              type: 'string'
            }
          ],
          requestBody: {
            content: {
              'application/json': {
                schema: {
                  properties: {
                    autocompletion: {
                      properties: {
                        query: {
                          type: 'string'
                        }
                      },
                      required: %w[query],
                      type: 'object'
                    }
                  },
                  type: 'object'
                }
              },
              'multipart/form-data': {
                schema: {
                  properties: {
                    'autocompletion[query]': {
                      required: true,
                      type: 'string'
                    }
                  },
                  type: 'object'
                }
              }
            },
            description: '',
            required: false
          },
          responses: {
            200 => {
              content: {
                'application/json': {
                  schema: {
                    items: {
                      type: 'string'
                    },
                    type: 'array'
                  }
                }
              },
              description: 'Success'
            },
            400 => {
              content: {
                'application/json': {
                  schema: {
                    type: 'object'
                  }
                }
              },
              description: 'Bad request'
            },
            401 => {
              content: {
                'application/json': {
                  schema: {
                    type: 'object'
                  }
                }
              },
              description: 'Not authorized'
            },
            403 => {
              content: {
                'application/json': {
                  schema: {
                    type: 'object'
                  }
                }
              },
              description: 'Forbidden'
            }
          },
          summary: 'Autocomplete Teams',
          tags: %w[Teams]
        }
      }
    }
  end

  its(:tag) { is_expected.to eq('Teams') }
  its(:to_h) { is_expected.to eq(expected_hash) }
end
