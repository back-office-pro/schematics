# frozen_string_literal: true

describe Schematics::Options::Delimiter do
  subject { described_class }

  it { is_expected.not_to be_multiple }

  its(:option_name) { is_expected.to eq(:delimiter) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:controller) { is_expected.to eq('dropdown') }
  its(:collection) { is_expected.to eq(%w[, .]) }
  its(:openai_description) { is_expected.to eq('The number thousands separator') }
  its(:openai_type) { is_expected.to eq('string') }

  its(:to_openai_schema) do
    is_expected.to eq(
      delimiter: {
        type: 'object',
        additionalProperties: false,
        required: %w[delimiter],
        properties: {
          delimiter: {
            type: 'string',
            description: 'The number thousands separator',
            enum: %w[, .]
          }
        }
      }
    )
  end
end
