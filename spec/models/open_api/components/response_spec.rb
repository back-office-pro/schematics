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

RSpec.describe OpenAPI::Components::Response do
  subject { described_class.new(code:, description:, data:) }

  let(:code) { 200 }
  let(:description) { 'Success' }
  let(:data) { %w[string] }
  let(:expected_hash) do
    {
      200 => {
        description:,
        content: {
          'application/json': {
            schema: {
              items: {
                type: 'string'
              },
              type: 'array'
            }
          }
        }
      }
    }
  end

  its(:to_h) { is_expected.to eq(expected_hash) }

  describe '.bad_request' do
    subject { described_class.bad_request }

    let(:expected_hash) do
      {
        400 => {
          description: 'Bad request',
          content: {
            'application/json': {
              schema: {
                type: 'object'
              }
            }
          }
        }
      }
    end

    its(:to_h) { is_expected.to eq(expected_hash) }
  end

  describe '.not_authorized' do
    subject { described_class.not_authorized }

    let(:expected_hash) do
      {
        401 => {
          description: 'Not authorized',
          content: {
            'application/json': {
              schema: {
                type: 'object'
              }
            }
          }
        }
      }
    end

    its(:to_h) { is_expected.to eq(expected_hash) }
  end
end
