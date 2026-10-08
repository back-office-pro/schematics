# frozen_string_literal: true

describe Schematics::Options::Required do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:required) }
  its(:input_type) { is_expected.to eq(:boolean) }
  its(:openai_description) { is_expected.to eq('Is the attribute required or not') }
  its(:openai_type) { is_expected.to eq('boolean') }

  its(:to_openai_schema) do
    is_expected.to eq(
      required: {
        type: 'object',
        additionalProperties: false,
        required: %w[required],
        properties: {
          required: {
            type: 'boolean',
            description: 'Is the attribute required or not'
          }
        }
      }
    )
  end
end
