# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Options::Icon do
  subject { described_class }

  before do
    allow(YAML)
      .to receive(:load_file)
      .with(File.expand_path('../../../../lib/icons.yml', __dir__))
      .and_return(%w[box users])
  end

  it { is_expected.not_to be_multiple }

  its(:option_name) { is_expected.to eq(:icon) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:collection) { is_expected.to eq(%i[box users]) }
  its(:controller) { is_expected.to eq('dropdowns--fa-icons-dropdown') }
  its(:openai_description) { is_expected.to eq('An icon which represents the entity or event') }
  its(:openai_type) { is_expected.to eq('string') }

  its(:to_openai_schema) do
    is_expected.to eq(
      icon: {
        type: 'object',
        additionalProperties: false,
        required: %w[icon],
        properties: {
          icon: {
            type: 'string',
            description: 'An icon which represents the entity or event',
            enum: %w[box users]
          }
        }
      }
    )
  end
end
