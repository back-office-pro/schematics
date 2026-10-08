# frozen_string_literal: true

describe Schematics::Options::Default do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:default) }
  its(:input_type) { is_expected.to eq(:polymorphic) }
  its(:openai_description) { is_expected.to eq('Default value of the attribute') }
  its(:openai_type) { is_expected.to eq('string') }

  its(:to_openai_schema) do
    is_expected.to eq(
      default: {
        type: 'object',
        additionalProperties: false,
        required: %w[default],
        properties: {
          default: {
            type: 'string',
            description: 'Default value of the attribute'
          }
        }
      }
    )
  end
end
