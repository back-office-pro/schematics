# frozen_string_literal: true

describe Schematics::Options::Readonly do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:readonly) }
  its(:input_type) { is_expected.to eq(:boolean) }
  its(:openai_description) { is_expected.to eq('Is the attribute readonly or not') }
  its(:openai_type) { is_expected.to eq('boolean') }

  its(:to_openai_schema) do
    is_expected.to eq(
      readonly: {
        type: 'object',
        additionalProperties: false,
        required: %w[readonly],
        properties: {
          readonly: {
            type: 'boolean',
            description: 'Is the attribute readonly or not'
          }
        }
      }
    )
  end
end
