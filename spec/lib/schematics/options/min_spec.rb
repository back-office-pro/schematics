# frozen_string_literal: true

describe Schematics::Options::Min do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:min) }
  its(:input_type) { is_expected.to eq(:number) }
  its(:min) { is_expected.to be_zero }
  its(:openai_description) { is_expected.to eq('The minimum length of the text') }
  its(:openai_type) { is_expected.to eq('number') }

  its(:to_openai_schema) do
    is_expected.to eq(
      min: {
        type: 'object',
        additionalProperties: false,
        required: %w[min],
        properties: {
          min: {
            type: 'number',
            description: 'The minimum length of the text'
          }
        }
      }
    )
  end
end
