# frozen_string_literal: true

describe Schematics::Options::Schemes do
  subject { described_class }

  it { is_expected.to be_multiple }

  its(:option_name) { is_expected.to eq(:schemes) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:controller) { is_expected.to eq('dropdown') }
  its(:collection) { is_expected.to eq(%w[http https]) }
  its(:openai_description) { is_expected.to eq('The URL schemes') }
  its(:openai_type) { is_expected.to eq('array') }

  its(:to_openai_schema) do
    is_expected.to eq(
      schemes: {
        type: 'object',
        additionalProperties: false,
        required: %w[schemes],
        properties: {
          schemes: {
            type: 'array',
            description: 'The URL schemes',
            items: {
              type: 'string',
              enum: %w[http https]
            }
          }
        }
      }
    )
  end
end
