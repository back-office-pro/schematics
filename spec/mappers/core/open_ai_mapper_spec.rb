# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::OpenAIMapper do
  subject(:mapper) { described_class.new }

  describe '#call' do
    subject { mapper.call(params) }

    let(:params) { JSON.parse(file_fixture('openai.json').read) }
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
              type: 'has_and_belongs_to_many',
              name: 'projects'
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
              type: 'has_and_belongs_to_many',
              name: 'projects'
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
