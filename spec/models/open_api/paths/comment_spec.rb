# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Paths::Comment do
  subject { described_class.new(entity:) }

  let(:schema) { Schematics::Schema.new(name: 'demo') }
  let(:entity) { schema.find_entity_by_name('team') }
  let(:expected_hash) do
    {
      '/teams/{id}/comments': {
        post: {
          operationId: 'Team_Comment',
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
                    comment: {
                      properties: {
                        author_id: {
                          type: 'string'
                        },
                        content: {
                          type: 'string'
                        }
                      },
                      required: %w[
                        content
                        author_id
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
                    'comment[content]': {
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
            201 => {
              content: {
                'application/json': {
                  schema: {
                    properties: {
                      author: {
                        properties: {
                          full_name: {
                            type: 'string'
                          },
                          id: {
                            type: 'string'
                          }
                        },
                        type: 'object'
                      },
                      content: {
                        type: 'string'
                      },
                      created_at: {
                        format: 'date-time',
                        type: 'string'
                      },
                      id: {
                        type: 'string'
                      },
                      record: {
                        properties: {
                          full_name: {
                            type: 'string'
                          },
                          id: {
                            type: 'string'
                          }
                        },
                        type: 'object'
                      },
                      role: {
                        properties: {
                          id: {
                            type: 'string'
                          },
                          name: {
                            type: 'string'
                          }
                        },
                        type: 'object'
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
          summary: 'Comment Team',
          tags: %w[Teams]
        }
      }
    }
  end

  its(:tag) { is_expected.to eq('Teams') }
  its(:to_h) { is_expected.to eq(expected_hash) }
end
