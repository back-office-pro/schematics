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

RSpec.describe OpenAPI::Components::Request do
  subject { described_class.new(entity:) }

  let(:schema) { Schematics::Schema.new }
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
