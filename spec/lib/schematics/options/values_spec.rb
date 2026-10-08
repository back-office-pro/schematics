# frozen_string_literal: true

describe Schematics::Options::Values do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:values) }
  its(:input_type) { is_expected.to eq(:array) }
  its(:openai_description) { is_expected.to eq('The enumeration values') }
  its(:openai_type) { is_expected.to eq('array') }

  its(:to_openai_schema) do
    is_expected.to eq(
      values: {
        type: 'object',
        additionalProperties: false,
        required: %w[values],
        properties: {
          values: {
            type: 'array',
            description: 'The enumeration values',
            items: { type: 'string' }
          }
        }
      }
    )
  end
end
