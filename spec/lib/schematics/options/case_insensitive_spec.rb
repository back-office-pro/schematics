# frozen_string_literal: true

describe Schematics::Options::CaseInsensitive do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:case_insensitive) }
  its(:input_type) { is_expected.to eq(:boolean) }
  its(:openai_description) { is_expected.to eq('Is the string case insensitive or not') }
  its(:openai_type) { is_expected.to eq('boolean') }

  its(:to_openai_schema) do
    is_expected.to eq(
      case_insensitive: {
        type: 'object',
        additionalProperties: false,
        required: %w[case_insensitive],
        properties: {
          case_insensitive: {
            type: 'boolean',
            description: 'Is the string case insensitive or not'
          }
        }
      }
    )
  end
end
