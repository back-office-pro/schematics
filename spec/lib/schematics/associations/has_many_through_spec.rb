# frozen_string_literal: true

describe Schematics::Associations::HasManyThrough do
  subject(:association) do
    described_class.new(belongs_to: through, through: belongs_to.inverse_association)
  end

  let(:schema) do
    Schematics::Schema.new(data: [{ name: 'schema' }, { name: 'entity' }])
  end
  let(:entity) do
    Schematics::Entities::Entity.new(
      schema:,
      name: 'attribute',
      options: {
        descriptor: 'name'
      },
      attributes: [
        { name: 'name', type: 'string' }
      ]
    )
  end
  let(:through_entity) do
    Schematics::Entities::Entity.new(
      schema:,
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
    Schematics::Attributes::BelongsTo.new(entity: through_entity, name: 'schema')
  end
  let(:through) do
    Schematics::Attributes::BelongsTo.new(entity:, name: 'entity')
  end

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }

  its(:type) { is_expected.to eq('has_many') }
  its(:name) { is_expected.to eq('attributes') }
  its(:class_name) { is_expected.to eq('Attribute') }
  its(:column_name) { is_expected.to eq('entity_id') }
  its(:source) { is_expected.to eq('attributes') }
  its(:open_api_type) { is_expected.to eq([{ id!: String }]) }
  its(:weight) { is_expected.to eq(3) }
  its(:to_spec) { is_expected.to eq('A schema has many **attributes** through **entities**') }
  its('descriptor.name') { is_expected.to eq('name') }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      scope :with_attributes, -> { includes([:attributes]) }
      has_many :attributes,
              -> { with_deleted },
              class_name: 'Attribute',
              foreign_key: 'entity_id',
              through: :entities,
              source: :attributes
    RUBY
  end
end
