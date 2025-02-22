# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Components::Request do
  subject { described_class.new(entity:) }

  let(:schema) { Schematics::Schema.new(name: 'demo') }
  let(:entity) { schema.find_entity_by_name('team') }
  let(:expected_hash) do
    {
      required: false,
      description: '',
      content: {
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
        },
        'application/json': {
          schema: {
            properties: {
              team: {
                properties: {
                  name: { type: 'string' }
                },
                required: %w[name],
                type: 'object'
              }
            },
            type: 'object'
          }
        }
      }
    }
  end

  its(:to_h) { is_expected.to eq(expected_hash) }
end
