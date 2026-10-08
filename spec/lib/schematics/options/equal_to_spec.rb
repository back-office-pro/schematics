# frozen_string_literal: true

describe Schematics::Options::EqualTo do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:equal_to) }
  its(:input_type) { is_expected.to eq(:number) }
  its(:min) { is_expected.to be_nil }
  its(:openai_description) { is_expected.to eq('The number should be equal to') }
  its(:openai_type) { is_expected.to eq('number') }

  its(:to_openai_schema) do
    is_expected.to eq(
      equal_to: {
        type: 'object',
        additionalProperties: false,
        required: %w[equal_to],
        properties: {
          equal_to: {
            type: 'number',
            description: 'The number should be equal to'
          }
        }
      }
    )
  end
end
