# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Options::Values do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:values) }
  its(:input_type) { is_expected.to eq(:array) }
  its(:openai_description) { is_expected.to eq('The enumeration values') }
  its(:openai_type) { is_expected.to eq('array') }

  its(:to_openai_schema) do
    is_expected.to eq(
      values: {
        type: 'object',
        additionalProperties: false,
        required: %w[values],
        properties: {
          values: {
            type: 'array',
            description: 'The enumeration values',
            items: { type: 'string' }
          }
        }
      }
    )
  end
end
