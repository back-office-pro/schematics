# frozen_string_literal: true

describe Schematics::Associations::HasOneThrough do
  subject(:association) { described_class.new(belongs_to, through) }

  let(:parent_entity) do
    Schematics::Entities::Entity.create(
      name: 'schema',
      descriptor: 'title',
      attributes: [{ name: 'title', type: 'string' }]
    )
  end
  let(:entity) do
    Schematics::Entities::Entity.create(
      name: 'attribute',
      descriptor: 'name',
      attributes: [{ name: 'name', type: 'string' }]
    )
  end
  let(:through_entity) do
    Schematics::Entities::Entity.create(
      name: 'entity',
      descriptor: 'type',
      attributes: [{ name: 'type', type: 'string' }]
    )
  end
  let(:belongs_to) do
    Schematics::Attributes::Attribute.create(through_entity, name: 'schema', type: 'belongs_to')
  end
  let(:through) do
    Schematics::Attributes::Attribute.create(entity, name: 'entity', type: 'belongs_to')
  end

  before do
    belongs_to.inverse_entity = parent_entity
  end

  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }

  its(:type) { is_expected.to eq('has_one') }
  its(:name) { is_expected.to eq('schema') }
  its(:class_name) { is_expected.to eq('Schema') }
  its('descriptor.name') { is_expected.to eq('title') }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      schema&.title&.parameterize(separator: ' ')
    RUBY
  end

  its('to_str.squish') do
    is_expected.to eq <<~RUBY.squish
      has_one :schema,
              class_name: 'Schema',
              foreign_key: 'schema_id',
              through: :entity,
              source: :schema
    RUBY
  end

  context 'when association has a name collision' do
    before { association.prefixed = true }

    its(:name) { is_expected.to eq('entity_schema') }
  end
end
