# frozen_string_literal: true

describe Schematics::Options::Height do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:height) }
  its(:input_type) { is_expected.to eq(:number) }
  its(:min) { is_expected.to be_zero }
  its(:openai_description) { is_expected.to eq('The height of the image in pixels') }
  its(:openai_type) { is_expected.to eq('number') }

  its(:to_openai_schema) do
    is_expected.to eq(
      height: {
        type: 'object',
        additionalProperties: false,
        required: %w[height],
        properties: {
          height: {
            type: 'number',
            description: 'The height of the image in pixels'
          }
        }
      }
    )
  end
end
