# frozen_string_literal: true

describe Schematics::Options::Translated do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:translated) }
  its(:input_type) { is_expected.to eq(:boolean) }
  its(:openai_description) { is_expected.to eq('Is the text translated or not') }
  its(:openai_type) { is_expected.to eq('boolean') }

  its(:to_openai_schema) do
    is_expected.to eq(
      translated: {
        type: 'object',
        additionalProperties: false,
        required: %w[translated],
        properties: {
          translated: {
            type: 'boolean',
            description: 'Is the text translated or not'
          }
        }
      }
    )
  end
end
