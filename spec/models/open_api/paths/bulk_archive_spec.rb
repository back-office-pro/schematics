# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Paths::BulkArchive do
  subject { described_class.new(entity:) }

  let(:schema) { Schematics::Schema.new(name: 'demo') }
  let(:entity) { schema.find_entity_by_name('team') }
  let(:expected_hash) do
    {
      '/teams/bulk-actions': {
        post: {
          operationId: 'Team_BulkArchive',
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
                    bulk_action: {
                      properties: {
                        ids: {
                          items: {
                            type: 'string'
                          },
                          type: 'array'
                        }
                      },
                      required: [
                        'ids'
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
                    'bulk_action[ids]': {
                      items: {
                        type: 'string'
                      },
                      required: true,
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
            200 => {
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
            }
          },
          summary: 'Bulk archive Teams',
          tags: %w[Teams]
        }
      }
    }
  end

  its(:tag) { is_expected.to eq('Teams') }
  its(:to_h) { is_expected.to eq(expected_hash) }
end
