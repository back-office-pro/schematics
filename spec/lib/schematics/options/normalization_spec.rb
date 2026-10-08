# frozen_string_literal: true

describe Schematics::Options::Normalization do
  subject { described_class }

  it { is_expected.not_to be_multiple }

  its(:option_name) { is_expected.to eq(:normalization) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:controller) { is_expected.to eq('dropdown') }
  its(:openai_description) { is_expected.to eq('The text formatting') }
  its(:openai_type) { is_expected.to eq('string') }

  its(:collection) do
    is_expected.to eq(
      [
        %w[Capitalize capitalize],
        %w[Lowercase downcase],
        %w[Uppercase upcase]
      ]
    )
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      normalization: {
        type: 'object',
        additionalProperties: false,
        required: %w[normalization],
        properties: {
          normalization: {
            type: 'string',
            description: 'The text formatting',
            enum: %w[capitalize downcase upcase]
          }
        }
      }
    )
  end
end
