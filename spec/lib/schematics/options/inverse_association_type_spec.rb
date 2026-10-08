# frozen_string_literal: true

describe Schematics::Options::InverseAssociationType do
  subject { described_class }

  it { is_expected.not_to be_multiple }

  its(:option_name) { is_expected.to eq(:inverse_association_type) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:collection) { is_expected.to eq([%w[One-to-many has_many], %w[One-to-one has_one]]) }
  its(:controller) { is_expected.to eq('dropdown') }
  its(:openai_description) { is_expected.to eq('The inverse type of the association') }
  its(:openai_type) { is_expected.to eq('string') }

  its(:to_openai_schema) do
    is_expected.to eq(
      inverse_association_type: {
        type: 'object',
        additionalProperties: false,
        required: %w[inverse_association_type],
        properties: {
          inverse_association_type: {
            type: 'string',
            description: 'The inverse type of the association',
            enum: %w[has_many has_one]
          }
        }
      }
    )
  end
end
