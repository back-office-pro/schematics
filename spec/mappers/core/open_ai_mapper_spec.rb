# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::OpenAiMapper do
  subject(:mapper) { described_class.new }

  describe '#call' do
    subject { mapper.call(params) }

    let(:params) do
      {
        'id' => 'chatcmpl-9w3W4KvNsqwjpWB0Hlu7npXEAfouc',
        'object' => 'chat.completion',
        'created' => 1_723_623_568,
        'model' => 'gpt-4o-2024-08-06',
        'choices' => [
          {
            'index' => 0,
            'message' => {
              'role' => 'assistant',
              'content' => nil,
              'tool_calls' => [
                {
                  'id' => 'call_srjw8gg7dNWZcy9FVkkoWues',
                  'type' => 'function',
                  'function' => {
                    'name' => 'schema',
                    'arguments' => <<~JSON
                      {
                        "name": "project",
                        "options": {
                          "descriptor": "name",
                          "icon": "building"
                        },
                        "associations": [
                          {
                            "type": "has_and_belongs_to_many",
                            "name": "tasks"
                          },
                          {
                            "type": "has_and_belongs_to_many",
                            "name": "materials"
                          }
                        ],
                        "attributes": [
                          {
                            "name": "name",
                            "type": "string",
                            "options": {
                              "required": true
                            }
                          },
                          {
                            "name": "description",
                            "type": "text",
                            "options": {
                              "required": false
                            }
                          },
                          {
                            "name": "start_date",
                            "type": "date",
                            "options": {
                              "required": true
                            }
                          },
                          {
                            "name": "end_date",
                            "type": "date",
                            "options": {
                              "required": true
                            }
                          },
                          {
                            "name": "status",
                            "type": "enum",
                            "options": {
                              "required": true
                            }
                          },
                          {
                            "name": "budget",
                            "type": "decimal",
                            "options": {
                              "required": true
                            }
                          }
                        ]
                      }
                    JSON
                  }
                },
                {
                  'id' => 'call_AHJMcbQ7C0GAIIo7TVDfgdjE',
                  'type' => 'function',
                  'function' => {
                    'name' => 'schema',
                    'arguments' => <<~JSON
                      {
                        "name": "task",
                        "options": {
                          "descriptor": "title",
                          "icon": "tasks"
                        },
                        "associations": [
                          {
                            "type": "has_and_belongs_to_many",
                            "name": "projects"
                          }
                        ],
                        "attributes": [
                          {
                            "name": "title",
                            "type": "string",
                            "options": {
                              "required": true
                            }
                          },
                          {
                            "name": "description",
                            "type": "text",
                            "options": {
                              "required": false
                            }
                          },
                          {
                            "name": "due_date",
                            "type": "date",
                            "options": {
                              "required": true
                            }
                          },
                          {
                            "name": "priority",
                            "type": "enum",
                            "options": {
                              "required": true
                            }
                          },
                          {
                            "name": "completed",
                            "type": "boolean",
                            "options": {
                              "required": true
                            }
                          }
                        ]
                      }
                    JSON
                  }
                },
                {
                  'id' => 'call_mVmt8cycyz343j6ZDKxifI6e',
                  'type' => 'function',
                  'function' => {
                    'name' => 'schema',
                    'arguments' => <<~JSON
                      {
                        "name": "material",
                        "options": {
                          "descriptor": "name",
                          "icon": "shapes"
                        },
                        "associations": [
                          {
                            "type": "has_and_belongs_to_many",
                            "name": "projects"
                          }
                        ],
                        "attributes": [
                          {
                            "name": "name",
                            "type": "string",
                            "options": {
                              "required": true
                            }
                          },
                          {
                            "name": "quantity",
                            "type": "integer",
                            "options": {
                              "required": true
                            }
                          },
                          {
                            "name": "unit_cost",
                            "type": "decimal",
                            "options": {
                              "required": true
                            }
                          },
                          {
                            "name": "supplier",
                            "type": "string",
                            "options": {
                              "required": false
                            }
                          }
                        ]
                      }
                    JSON
                  }
                }
              ],
              'refusal' => nil
            },
            'logprobs' => nil,
            'finish_reason' => 'stop'
          }
        ],
        'usage' => {
          'prompt_tokens' => 8248,
          'completion_tokens' => 393,
          'total_tokens' => 8641
        },
        'system_fingerprint' => 'fp_2a322c9ffc'
      }
    end
    let(:expected_output) do
      {
        data: [
          {
            id: String,
            name: 'project',
            options: {
              descriptor: 'name',
              icon: 'building'
            },
            associations: [
              {
                type: 'has_and_belongs_to_many',
                name: 'tasks'
              },
              {
                type: 'has_and_belongs_to_many',
                name: 'materials'
              }
            ],
            attributes: [
              {
                id: String,
                name: 'name',
                type: 'string',
                options: {
                  required: true
                }
              },
              {
                id: String,
                name: 'description',
                type: 'text'
              },
              {
                id: String,
                name: 'start_date',
                type: 'date',
                options: {
                  required: true
                }
              },
              {
                id: String,
                name: 'end_date',
                type: 'date',
                options: {
                  required: true
                }
              },
              {
                id: String,
                name: 'status',
                type: 'enum',
                options: {
                  required: true
                }
              },
              {
                id: String,
                name: 'budget',
                type: 'decimal',
                options: {
                  required: true
                }
              }
            ]
          },
          {
            id: String,
            name: 'task',
            options: {
              descriptor: 'title',
              icon: 'tasks'
            },
            associations: [
              {
                type: 'has_and_belongs_to_many',
                name: 'projects'
              }
            ],
            attributes: [
              {
                id: String,
                name: 'title',
                type: 'string',
                options: {
                  required: true
                }
              },
              {
                id: String,
                name: 'description',
                type: 'text'
              },
              {
                id: String,
                name: 'due_date',
                type: 'date',
                options: {
                  required: true
                }
              },
              {
                id: String,
                name: 'priority',
                type: 'enum',
                options: {
                  required: true
                }
              },
              {
                id: String,
                name: 'completed',
                type: 'boolean',
                options: {
                  required: true
                }
              }
            ]
          },
          {
            id: String,
            name: 'material',
            options: {
              descriptor: 'name',
              icon: 'shapes'
            },
            associations: [
              {
                type: 'has_and_belongs_to_many',
                name: 'projects'
              }
            ],
            attributes: [
              {
                id: String,
                name: 'name',
                type: 'string',
                options: {
                  required: true
                }
              },
              {
                id: String,
                name: 'quantity',
                type: 'integer',
                options: {
                  required: true
                }
              },
              {
                id: String,
                name: 'unit_cost',
                type: 'decimal',
                options: {
                  required: true
                }
              },
              {
                id: String,
                name: 'supplier',
                type: 'string'
              }
            ]
          }
        ]
      }
    end

    it { is_expected.to match(expected_output) }
  end
end
