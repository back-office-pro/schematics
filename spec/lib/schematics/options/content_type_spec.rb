# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Options::ContentType do
  subject { described_class }

  before do
    allow(Mime::LOOKUP).to receive(:keys).and_return(['image/png'])
  end

  its(:option_name) { is_expected.to eq(:content_type) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:collection) { is_expected.to eq(['image/png']) }
  its(:controller) { is_expected.to eq('dropdown') }
  its(:openai_description) { is_expected.to eq('The content types of the attachment') }
  its(:openai_type) { is_expected.to eq('array') }

  it { is_expected.to be_multiple }

  its(:to_openai_schema) do
    is_expected.to eq(
      content_type: {
        type: 'object',
        additionalProperties: false,
        required: %w[content_type],
        properties: {
          content_type: {
            type: 'array',
            description: 'The content types of the attachment',
            items: {
              type: 'string',
              enum: %w[image/png]
            }
          }
        }
      }
    )
  end
end
