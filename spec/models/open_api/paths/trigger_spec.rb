# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Paths::Trigger do
  subject { described_class.new(entity:, event:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { schema.find_entity_by_name('subscription') }
  let(:event) { entity.find_event_by_name('cancel') }
  let(:expected_hash) do
    {
      '/subscription/state/cancel': {
        patch: {
          operationId: 'Subscription_Cancel',
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
          summary: 'Cancel subscription Subscription',
          tags: %w[Subscription]
        }
      }
    }
  end

  its(:tag) { is_expected.to eq('Subscription') }
  its(:to_h) { is_expected.to eq(expected_hash) }
end
