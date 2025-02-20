# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Paths::Index do
  subject { described_class.new(entity:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { schema.find_entity_by_name('team') }
  let(:expected_hash) do
    {
      '/teams': {
        get: {
          operationId: 'Team_Index',
          parameters: [
            {
              description: 'Filter by created_at',
              in: 'query',
              name: 'filter[created_at]',
              required: false,
              schema: {
                description: 'Filter by created_at',
                format: 'date-time',
                type: 'string'
              }
            },
            {
              description: 'Filter by name',
              in: 'query',
              name: 'filter[name]',
              required: false,
              schema: {
                description: 'Filter by name',
                type: 'string'
              }
            },
            {
              description: 'Display archives',
              in: 'query',
              name: 'filter[with_deleted]',
              required: false,
              schema: {
                description: 'Display archives',
                type: 'boolean'
              }
            },
            {
              description: 'Items per page',
              in: 'query',
              name: 'limit',
              required: false,
              schema: {
                description: 'Items per page',
                type: 'integer'
              }
            },
            {
              description: 'Page number',
              in: 'query',
              name: 'page',
              required: false,
              schema: {
                description: 'Page number',
                type: 'integer'
              }
            },
            {
              description: 'Sort fields list separated by comma',
              in: 'query',
              name: 'sort',
              required: false,
              schema: {
                description: 'Sort fields list separated by comma',
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
          responses: {
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
            200 => {
              content: {
                'application/json': {
                  schema: {
                    items: {
                      properties: {
                        created_at: {
                          format: 'date-time',
                          type: 'string'
                        },
                        id: {
                          type: 'string'
                        },
                        name: {
                          type: 'string'
                        }
                      },
                      type: 'object'
                    },
                    type: 'array'
                  }
                }
              },
              description: 'Success',
              headers: {
                'current-page': {
                  description: 'Current page',
                  schema: {
                    type: 'integer'
                  }
                },
                'page-items': {
                  description: 'Items per page',
                  schema: {
                    type: 'integer'
                  }
                },
                'total-count': {
                  description: 'Total count of items',
                  schema: {
                    type: 'integer'
                  }
                },
                'total-pages': {
                  description: 'Pages count',
                  schema: {
                    type: 'integer'
                  }
                }
              }
            }
          },
          summary: 'List Teams',
          tags: %w[Teams]
        }
      }
    }
  end

  its(:tag) { is_expected.to eq('Teams') }
  its(:to_h) { is_expected.to eq(expected_hash) }
end
