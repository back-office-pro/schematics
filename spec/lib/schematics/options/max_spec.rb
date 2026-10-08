# frozen_string_literal: true

describe Schematics::Options::Max do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:max) }
  its(:input_type) { is_expected.to eq(:number) }
  its(:min) { is_expected.to be_zero }
  its(:openai_description) { is_expected.to eq('The maximum number of attachments') }
  its(:openai_type) { is_expected.to eq('number') }

  its(:to_openai_schema) do
    is_expected.to eq(
      max: {
        type: 'object',
        additionalProperties: false,
        required: %w[max],
        properties: {
          max: {
            type: 'number',
            description: 'The maximum number of attachments'
          }
        }
      }
    )
  end
end
