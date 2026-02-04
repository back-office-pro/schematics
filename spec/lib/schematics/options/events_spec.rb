# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Options::Events do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:events) }
  its(:input_type) { is_expected.to eq(:events) }
  its(:openai_type) { is_expected.to eq('array') }
  its(:openai_description) { is_expected.to eq('State machine events') }

  its(:to_openai_schema) do
    is_expected.to eq(
      events: {
        type: 'object',
        additionalProperties: false,
        required: %w[events],
        properties: {
          events: {
            type: 'array',
            description: 'State machine events',
            items: {
              type: 'object',
              properties: {
                name: { '$ref': '#/$defs/name' },
                icon: { '$ref': '#/$defs/icon' },
                color: {
                  type: 'string',
                  description: 'The event style',
                  enum: %w[primary secondary success danger warning]
                },
                confirm: {
                  type: 'boolean',
                  description: 'Does the event action need to be confirmed'
                },
                from: {
                  type: 'string',
                  description: 'The starting value of the event transition'
                },
                to: {
                  type: 'string',
                  description: 'The ending value of the event transition'
                }
              },
              additionalProperties: false,
              required: %w[name icon color confirm from to]
            }
          }
        }
      }
    )
  end
end
