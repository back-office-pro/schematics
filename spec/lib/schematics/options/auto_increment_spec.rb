# frozen_string_literal: true

describe Schematics::Options::AutoIncrement do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:auto_increment) }
  its(:input_type) { is_expected.to eq(:boolean) }
  its(:openai_description) { is_expected.to eq('Is the number auto incrementable or not') }
  its(:openai_type) { is_expected.to eq('boolean') }

  its(:to_openai_schema) do
    is_expected.to eq(
      auto_increment: {
        type: 'object',
        additionalProperties: false,
        required: %w[auto_increment],
        properties: {
          auto_increment: {
            type: 'boolean',
            description: 'Is the number auto incrementable or not'
          }
        }
      }
    )
  end
end
