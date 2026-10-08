# frozen_string_literal: true

describe Schematics::Options::Scale do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:scale) }
  its(:input_type) { is_expected.to eq(:number) }
  its(:min) { is_expected.to be_zero }
  its(:openai_type) { is_expected.to eq('number') }

  its(:openai_description) do
    is_expected.to eq('The number of digits following the decimal point in the number')
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      scale: {
        type: 'object',
        additionalProperties: false,
        required: %w[scale],
        properties: {
          scale: {
            type: 'number',
            description: 'The number of digits following the decimal point in the number'
          }
        }
      }
    )
  end
end
