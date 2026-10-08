# frozen_string_literal: true

describe Schematics::Options::StartDate do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:start_date) }
  its(:input_type) { is_expected.to eq(:boolean) }
  its(:openai_description) { is_expected.to eq('Is the date the start of a calendar range') }
  its(:openai_type) { is_expected.to eq('boolean') }

  its(:to_openai_schema) do
    is_expected.to eq(
      start_date: {
        type: 'object',
        additionalProperties: false,
        required: %w[start_date],
        properties: {
          start_date: {
            type: 'boolean',
            description: 'Is the date the start of a calendar range'
          }
        }
      }
    )
  end
end
