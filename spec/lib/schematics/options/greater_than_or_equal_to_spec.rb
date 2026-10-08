# frozen_string_literal: true

describe Schematics::Options::GreaterThanOrEqualTo do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:greater_than_or_equal_to) }
  its(:input_type) { is_expected.to eq(:number) }
  its(:min) { is_expected.to be_nil }
  its(:openai_description) { is_expected.to eq('The number should be greater than or equal to') }
  its(:openai_type) { is_expected.to eq('number') }

  its(:to_openai_schema) do
    is_expected.to eq(
      greater_than_or_equal_to: {
        type: 'object',
        additionalProperties: false,
        required: %w[greater_than_or_equal_to],
        properties: {
          greater_than_or_equal_to: {
            type: 'number',
            description: 'The number should be greater than or equal to'
          }
        }
      }
    )
  end
end
