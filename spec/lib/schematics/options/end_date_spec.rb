# frozen_string_literal: true

describe Schematics::Options::EndDate do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:end_date) }
  its(:input_type) { is_expected.to eq(:boolean) }
  its(:openai_description) { is_expected.to eq('Is the date the end of a calendar range') }
  its(:openai_type) { is_expected.to eq('boolean') }

  its(:to_openai_schema) do
    is_expected.to eq(
      end_date: {
        type: 'object',
        additionalProperties: false,
        required: %w[end_date],
        properties: {
          end_date: {
            type: 'boolean',
            description: 'Is the date the end of a calendar range'
          }
        }
      }
    )
  end
end
