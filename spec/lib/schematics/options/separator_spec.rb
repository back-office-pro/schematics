# frozen_string_literal: true

describe Schematics::Options::Separator do
  subject { described_class }

  it { is_expected.not_to be_multiple }

  its(:option_name) { is_expected.to eq(:separator) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:controller) { is_expected.to eq('dropdown') }
  its(:collection) { is_expected.to eq(%w[, .]) }
  its(:openai_description) { is_expected.to eq('The number decimal separator') }
  its(:openai_type) { is_expected.to eq('string') }

  its(:to_openai_schema) do
    is_expected.to eq(
      separator: {
        type: 'object',
        additionalProperties: false,
        required: %w[separator],
        properties: {
          separator: {
            type: 'string',
            description: 'The number decimal separator',
            enum: %w[, .]
          }
        }
      }
    )
  end
end
