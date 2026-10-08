# frozen_string_literal: true

describe Schematics::Entities::Descriptor do
  subject(:descriptor) { described_class.new(entity:, field_name:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) do
    Schematics::Entities::Entity.new(
      schema:,
      name: 'entity',
      options: {
        descriptor: 'type'
      },
      attributes: [
        name: 'type', type: 'string'
      ]
    )
  end
  let(:field_name) { 'type' }

  its(:field_name) { is_expected.to eq('type') }
  its(:joins) { is_expected.to be_empty }
  its(:allowed_field_names) { is_expected.to eq(%w[type]) }
  its(:field) { is_expected.to be_a(Schematics::Attributes::String) }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      def to_s
        type_formatted || id_formatted
      end
    RUBY
  end
end
