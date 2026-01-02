# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Paths::Import do
  subject { described_class.new(entity:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { schema.find_entity_by_name('team') }
  let(:expected_hash) do
    {
      '/teams/imports': {
        post: {
          operationId: 'Team_Import',
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
                    import: {
                      properties: {
                        author_id: {
                          type: 'string'
                        },
                        file: {
                          format: 'binary',
                          type: 'string'
                        },
                        resources: {
                          type: 'object'
                        }
                      },
                      required: [
                        'author_id'
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
                    'import[file]': {
                      format: 'binary',
                      required: false,
                      type: 'string'
                    },
                    'import[resources]': {
                      default: [],
                      required: false,
                      type: 'object'
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
                      created_at: {
                        format: 'date-time',
                        type: 'string'
                      },
                      file: {
                        type: 'string'
                      },
                      id: {
                        type: 'string'
                      },
                      import_errors: {
                        type: 'object'
                      },
                      model: {
                        type: 'string'
                      },
                      progress: {
                        format: 'float',
                        type: 'number'
                      },
                      resources: {
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
                      },
                      state: {
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
          summary: 'Import Teams',
          tags: %w[Teams]
        }
      }
    }
  end

  its(:tag) { is_expected.to eq('Teams') }
  its(:to_h) { is_expected.to eq(expected_hash) }
end
