# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Paths::Trigger do
  subject { described_class.new(entity:, event:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { schema.find_entity_by_name('backup') }
  let(:event) { entity.find_event_by_name('restore_database') }
  let(:expected_hash) do
    {
      '/backups/{id}/state/restore_database': {
        patch: {
          operationId: 'Backup_Restore_database',
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
            405 => {
              content: {
                'application/json': {
                  schema: {
                    type: 'object'
                  }
                }
              },
              description: 'Action not authorized'
            }
          },
          summary: 'Restore database Backup',
          tags: %w[Backups]
        }
      }
    }
  end

  its(:tag) { is_expected.to eq('Backups') }
  its(:to_h) { is_expected.to eq(expected_hash) }
end
