# frozen_string_literal: true

describe Schematics::Options::Unit do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:unit) }
  its(:input_type) { is_expected.to eq(:string) }
  its(:openai_description) { is_expected.to eq('The number unit') }
  its(:openai_type) { is_expected.to eq('string') }

  its(:to_openai_schema) do
    is_expected.to eq(
      unit: {
        type: 'object',
        additionalProperties: false,
        required: %w[unit],
        properties: {
          unit: {
            type: 'string',
            description: 'The number unit'
          }
        }
      }
    )
  end
end
