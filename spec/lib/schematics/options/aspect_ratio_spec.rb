# frozen_string_literal: true

describe Schematics::Options::AspectRatio do
  subject { described_class }

  it { is_expected.to be_multiple }

  its(:option_name) { is_expected.to eq(:aspect_ratio) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:controller) { is_expected.to eq('dropdown') }
  its(:openai_description) { is_expected.to eq('The aspect ratios of the image') }
  its(:openai_type) { is_expected.to eq('array') }

  its(:collection) do
    is_expected.to eq(
      [
        %w[16/9 is_16_9],
        %w[4/3 is_4_3],
        %w[Landscape landscape],
        %w[Square square]
      ]
    )
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      aspect_ratio: {
        type: 'object',
        additionalProperties: false,
        required: %w[aspect_ratio],
        properties: {
          aspect_ratio: {
            type: 'array',
            description: 'The aspect ratios of the image',
            items: {
              type: 'string',
              enum: %w[is_16_9 is_4_3 landscape square]
            }
          }
        }
      }
    )
  end
end
