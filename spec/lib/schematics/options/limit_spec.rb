# frozen_string_literal: true

describe Schematics::Options::Limit do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:limit) }
  its(:input_type) { is_expected.to eq(:number) }
  its(:min) { is_expected.to be_zero }
  its(:openai_description) { is_expected.to eq('The maximum length of the text') }
  its(:openai_type) { is_expected.to eq('number') }

  its(:to_openai_schema) do
    is_expected.to eq(
      limit: {
        type: 'object',
        additionalProperties: false,
        required: %w[limit],
        properties: {
          limit: {
            type: 'number',
            description: 'The maximum length of the text'
          }
        }
      }
    )
  end
end
