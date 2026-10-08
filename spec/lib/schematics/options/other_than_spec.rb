# frozen_string_literal: true

describe Schematics::Options::OtherThan do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:other_than) }
  its(:input_type) { is_expected.to eq(:number) }
  its(:min) { is_expected.to be_nil }
  its(:openai_description) { is_expected.to eq('The number should be other than') }
  its(:openai_type) { is_expected.to eq('number') }

  its(:to_openai_schema) do
    is_expected.to eq(
      other_than: {
        type: 'object',
        additionalProperties: false,
        required: %w[other_than],
        properties: {
          other_than: {
            type: 'number',
            description: 'The number should be other than'
          }
        }
      }
    )
  end
end
