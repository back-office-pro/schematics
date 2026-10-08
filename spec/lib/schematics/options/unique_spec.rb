# frozen_string_literal: true

describe Schematics::Options::Unique do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:unique) }
  its(:input_type) { is_expected.to eq(:boolean) }
  its(:openai_description) { is_expected.to eq('Is the text unique or not') }
  its(:openai_type) { is_expected.to eq('boolean') }

  its(:to_openai_schema) do
    is_expected.to eq(
      unique: {
        type: 'object',
        additionalProperties: false,
        required: %w[unique],
        properties: {
          unique: {
            type: 'boolean',
            description: 'Is the text unique or not'
          }
        }
      }
    )
  end
end
