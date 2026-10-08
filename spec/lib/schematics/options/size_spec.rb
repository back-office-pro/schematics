# frozen_string_literal: true

describe Schematics::Options::Size do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:size) }
  its(:input_type) { is_expected.to eq(:number) }
  its(:min) { is_expected.to be_zero }
  its(:openai_description) { is_expected.to eq('The maximum size of the attachment in megabytes') }
  its(:openai_type) { is_expected.to eq('number') }

  its(:to_openai_schema) do
    is_expected.to eq(
      size: {
        type: 'object',
        additionalProperties: false,
        required: %w[size],
        properties: {
          size: {
            type: 'number',
            description: 'The maximum size of the attachment in megabytes'
          }
        }
      }
    )
  end
end
