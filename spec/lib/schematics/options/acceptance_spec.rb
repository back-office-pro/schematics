# frozen_string_literal: true

describe Schematics::Options::Acceptance do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:acceptance) }
  its(:input_type) { is_expected.to eq(:boolean) }
  its(:openai_description) { is_expected.to eq('Does the attribute must be accepted or not') }
  its(:openai_type) { is_expected.to eq('boolean') }

  its(:to_openai_schema) do
    is_expected.to eq(
      acceptance: {
        type: 'object',
        additionalProperties: false,
        required: %w[acceptance],
        properties: {
          acceptance: {
            type: 'boolean',
            description: 'Does the attribute must be accepted or not'
          }
        }
      }
    )
  end
end
