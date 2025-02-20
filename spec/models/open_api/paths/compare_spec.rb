# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Paths::Compare do
  subject { described_class.new(entity:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { schema.find_entity_by_name('team') }
  let(:expected_hash) do
    {
      '/teams/comparisons': {
        post: {
          operationId: 'Team_Compare',
          parameters: [
            {
              description: 'Inflect payload keys. Possible values are camel, dash, snake or pascal.', # rubocop:disable Layout/LineLength
              in: 'header',
              name: 'x-api-inflection',
              required: false,
              schema: {
                description: 'Inflect payload keys. Possible values are camel, dash, snake or pascal.', # rubocop:disable Layout/LineLength
                type: 'string'
              }
            }
          ],
          requestBody: {
            content: {
              'application/json': {
                schema: {
                  properties: {
                    comparison: {
                      properties: {
                        ids: {
                          items: {
                            type: 'string'
                          },
                          type: 'array'
                        }
                      },
                      type: 'object'
                    }
                  },
                  type: 'object'
                }
              },
              'multipart/form-data': {
                schema: {
                  properties: {
                    'comparison[ids][]': {
                      items: {
                        type: 'string'
                      },
                      required: false,
                      type: 'array'
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
            201 => {
              content: {
                'application/json': {
                  schema: {
                    properties: {
                      created_at: {
                        format: 'date-time',
                        type: 'string'
                      },
                      id: {
                        type: 'string'
                      },
                      ids: {
                        items: {
                          type: 'string'
                        },
                        type: 'array'
                      },
                      model: {
                        type: 'string'
                      }
                    },
                    type: 'object'
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
            },
            422 => {
              content: {
                'application/json': {
                  schema: {
                    type: 'object'
                  }
                }
              },
              description: 'Unprocessable content'
            }
          },
          summary: 'Compare Teams',
          tags: %w[Teams]
        }
      }
    }
  end

  its(:tag) { is_expected.to eq('Teams') }
  its(:to_h) { is_expected.to eq(expected_hash) }
end
