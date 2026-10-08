# frozen_string_literal: true

describe Schematics::Options::Confirm do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:confirm) }
  its(:input_type) { is_expected.to eq(:boolean) }
  its(:openai_description) { is_expected.to eq('Has the password to be confirmed or not') }
  its(:openai_type) { is_expected.to eq('boolean') }

  its(:to_openai_schema) do
    is_expected.to eq(
      confirm: {
        type: 'object',
        additionalProperties: false,
        required: %w[confirm],
        properties: {
          confirm: {
            type: 'boolean',
            description: 'Has the password to be confirmed or not'
          }
        }
      }
    )
  end
end
