# frozen_string_literal: true

describe Schematics::Associations::HasOneThrough do
  subject(:association) { described_class.new(belongs_to:, through:) }

  let(:parent_entity) do
    Schematics::Entities::Entity.new(
      name: 'schema',
      options: {
        descriptor: 'title'
      },
      attributes: [
        { name: 'title', type: 'string' }
      ]
    )
  end
  let(:entity) do
    Schematics::Entities::Entity.new(
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

  before do
    belongs_to.inverse_entity = parent_entity
  end

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }

  its(:type) { is_expected.to eq('has_one') }
  its(:name) { is_expected.to eq('schema') }
  its(:class_name) { is_expected.to eq('Schema') }
  its(:open_api_type) { is_expected.to eq(id!: String) }
  its(:weight) { is_expected.to eq(3) }
  its(:search_column) { is_expected.to eq(:schema_title) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:schema_title_i_cont) }
  its('descriptor.name') { is_expected.to eq('title') }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_one :schema,
              class_name: 'Schema',
              foreign_key: 'schema_id',
              through: :entity,
              source: :schema,
              autosave: true
    RUBY
  end

  context 'when association has a name collision' do
    before { association.prefixed = true }

    its(:name) { is_expected.to eq('entity_schema') }
  end
end
