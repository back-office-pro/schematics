# frozen_string_literal: true

describe Schematics::Options::LessThan do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:less_than) }
  its(:input_type) { is_expected.to eq(:number) }
  its(:min) { is_expected.to be_nil }
  its(:openai_description) { is_expected.to eq('The number should be less than') }
  its(:openai_type) { is_expected.to eq('number') }

  its(:to_openai_schema) do
    is_expected.to eq(
      less_than: {
        type: 'object',
        additionalProperties: false,
        required: %w[less_than],
        properties: {
          less_than: {
            type: 'number',
            description: 'The number should be less than'
          }
        }
      }
    )
  end
end
