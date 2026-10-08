# frozen_string_literal: true

describe Schematics::Options::Width do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:width) }
  its(:input_type) { is_expected.to eq(:number) }
  its(:min) { is_expected.to be_zero }
  its(:openai_description) { is_expected.to eq('The width of the image in pixels') }
  its(:openai_type) { is_expected.to eq('number') }

  its(:to_openai_schema) do
    is_expected.to eq(
      width: {
        type: 'object',
        additionalProperties: false,
        required: %w[width],
        properties: {
          width: {
            type: 'number',
            description: 'The width of the image in pixels'
          }
        }
      }
    )
  end
end
