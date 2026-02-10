# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Options::Delimiter do
  subject { described_class }

  it { is_expected.not_to be_multiple }

  its(:option_name) { is_expected.to eq(:delimiter) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:controller) { is_expected.to eq('dropdown') }
  its(:collection) { is_expected.to eq(%w[, .]) }
  its(:openai_description) { is_expected.to eq('The number thousands separator') }
  its(:openai_type) { is_expected.to eq('string') }

  its(:to_openai_schema) do
    is_expected.to eq(
      delimiter: {
        type: 'object',
        additionalProperties: false,
        required: %w[delimiter],
        properties: {
          delimiter: {
            type: 'string',
            description: 'The number thousands separator',
            enum: %w[, .]
          }
        }
      }
    )
  end
end
