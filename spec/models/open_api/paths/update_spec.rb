# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Paths::Update do
  subject { described_class.new(entity:, http_method:) }

  let(:schema) { Schematics::Schema.new(name: 'demo') }
  let(:entity) { schema.find_entity_by_name('team') }
  let(:http_method) { :put }
  let(:expected_hash) do
    {
      '/teams/{id}': {
        put: {
          operationId: 'Team_Update_Put',
          parameters: [
            {
              in: 'path',
              name: 'id',
              required: false,
              schema: {
                type: 'string'
              }
            },
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
                    team: {
                      properties: {
                        name: {
                          type: 'string'
                        }
                      },
                      required: [
                        'name'
                      ],
                      type: 'object'
                    }
                  },
                  type: 'object'
                }
              },
              'multipart/form-data': {
                schema: {
                  properties: {
                    'team[name]': {
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
            204 => {
              content: {
                'application/json': {
                  schema: {
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
            404 => {
              content: {
                'application/json': {
                  schema: {
                    type: 'object'
                  }
                }
              },
              description: 'Not found'
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
          summary: 'Edit Team',
          tags: %w[Teams]
        }
      }
    }
  end

  its(:tag) { is_expected.to eq('Teams') }
  its(:to_h) { is_expected.to eq(expected_hash) }
end
