# frozen_string_literal: true

describe Schematics::Options::Length do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:length) }
  its(:input_type) { is_expected.to eq(:number) }
  its(:min) { is_expected.to be_zero }
  its(:openai_description) { is_expected.to eq('The exact length of the text') }
  its(:openai_type) { is_expected.to eq('number') }

  its(:to_openai_schema) do
    is_expected.to eq(
      length: {
        type: 'object',
        additionalProperties: false,
        required: %w[length],
        properties: {
          length: {
            type: 'number',
            description: 'The exact length of the text'
          }
        }
      }
    )
  end
end
