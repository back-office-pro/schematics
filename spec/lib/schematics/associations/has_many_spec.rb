# frozen_string_literal: true

describe Schematics::Associations::HasMany do
  subject(:association) { described_class.new(belongs_to:) }

  let(:entity) do
    Schematics::Entities::Entity.new(
      name: 'entity',
      options: {
        descriptor: 'type'
      },
      attributes: [
        { name: 'type', type: 'string' }
      ]
    )
  end
  let(:belongs_to) do
    Schematics::Attributes::BelongsTo.new(entity:, name: 'schema', options:)
  end
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }

  its(:type) { is_expected.to eq('has_many') }
  its(:name) { is_expected.to eq('entities') }
  its(:class_name) { is_expected.to eq('Entity') }
  its(:open_api_type) { is_expected.to eq([{ id!: String }]) }
  its(:weight) { is_expected.to eq(3) }
  its('descriptor.name') { is_expected.to eq('type') }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_many :entities,
              class_name: 'Entity',
              foreign_key: 'schema_id',
              inverse_of: :schema,
              dependent: :nullify
    RUBY
  end

  context 'when belongs_to is required' do
    let(:options) do
      {
        required: true
      }
    end

    its(:to_str) do
      is_expected.to eq <<~RUBY
        has_many :entities,
                class_name: 'Entity',
                foreign_key: 'schema_id',
                inverse_of: :schema,
                dependent: :destroy
      RUBY
    end
  end

  context 'when association has a name collision' do
    before { association.prefixed = true }

    its(:name) { is_expected.to eq('schema_entities') }
  end
end
