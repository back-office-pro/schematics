# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Options::Normalization do
  subject { described_class }

  it { is_expected.not_to be_multiple }

  its(:option_name) { is_expected.to eq(:normalization) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:controller) { is_expected.to eq('dropdown') }
  its(:openai_description) { is_expected.to eq('The text formatting') }
  its(:openai_type) { is_expected.to eq('string') }

  its(:collection) do
    is_expected.to eq(
      [
        %w[Capitalize capitalize],
        %w[Lowercase downcase],
        %w[Uppercase upcase]
      ]
    )
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      normalization: {
        type: 'object',
        additionalProperties: false,
        required: %w[normalization],
        properties: {
          normalization: {
            type: 'string',
            description: 'The text formatting',
            enum: %w[capitalize downcase upcase]
          }
        }
      }
    )
  end
end
