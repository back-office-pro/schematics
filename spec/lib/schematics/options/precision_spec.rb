# frozen_string_literal: true

describe Schematics::Options::Precision do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:precision) }
  its(:input_type) { is_expected.to eq(:number) }
  its(:min) { is_expected.to be_zero }
  its(:openai_description) { is_expected.to eq('The number of digits in the number') }
  its(:openai_type) { is_expected.to eq('number') }

  its(:to_openai_schema) do
    is_expected.to eq(
      precision: {
        type: 'object',
        additionalProperties: false,
        required: %w[precision],
        properties: {
          precision: {
            type: 'number',
            description: 'The number of digits in the number'
          }
        }
      }
    )
  end
end
