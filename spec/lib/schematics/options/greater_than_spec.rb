# frozen_string_literal: true

describe Schematics::Options::GreaterThan do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:greater_than) }
  its(:input_type) { is_expected.to eq(:number) }
  its(:min) { is_expected.to be_nil }
  its(:openai_description) { is_expected.to eq('The number should be greater than') }
  its(:openai_type) { is_expected.to eq('number') }

  its(:to_openai_schema) do
    is_expected.to eq(
      greater_than: {
        type: 'object',
        additionalProperties: false,
        required: %w[greater_than],
        properties: {
          greater_than: {
            type: 'number',
            description: 'The number should be greater than'
          }
        }
      }
    )
  end
end
