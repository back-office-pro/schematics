# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Paths::Forward do
  subject { described_class.new(entity:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { schema.find_entity_by_name('team') }
  let(:expected_hash) do
    {
      '/teams/{id}/emailings': {
        post: {
          operationId: 'Team_Forward',
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
                    emailing: {
                      properties: {
                        email_template_id: {
                          type: 'string'
                        },
                        ics_attachment: {
                          type: 'boolean'
                        },
                        pdf_attachment: {
                          type: 'boolean'
                        },
                        recipient_ids: {
                          items: {
                            type: 'string'
                          },
                          type: 'array'
                        },
                        sender_id: {
                          type: 'string'
                        },
                        svg_attachment: {
                          type: 'boolean'
                        }
                      },
                      required: %w[
                        email_template_id
                        sender_id
                        recipient_ids
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
                    'emailing[email_template_id]': {
                      required: true,
                      type: 'string'
                    },
                    'emailing[ics_attachment]': {
                      required: false,
                      type: 'boolean'
                    },
                    'emailing[pdf_attachment]': {
                      required: false,
                      type: 'boolean'
                    },
                    'emailing[recipient_ids][]': {
                      items: {
                        type: 'string'
                      },
                      required: true,
                      type: 'array'
                    },
                    'emailing[svg_attachment]': {
                      required: false,
                      type: 'boolean'
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
                      email_template: {
                        properties: {
                          id: {
                            type: 'string'
                          },
                          subject: {
                            type: 'string'
                          }
                        },
                        type: 'object'
                      },
                      ics_attachment: {
                        type: 'boolean'
                      },
                      id: {
                        type: 'string'
                      },
                      pdf_attachment: {
                        type: 'boolean'
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
                      },
                      sender: {
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
                      svg_attachment: {
                        type: 'boolean'
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
          summary: 'Forward Team',
          tags: %w[Teams]
        }
      }
    }
  end

  its(:tag) { is_expected.to eq('Teams') }
  its(:to_h) { is_expected.to eq(expected_hash) }
end
