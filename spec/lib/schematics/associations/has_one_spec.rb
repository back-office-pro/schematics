# frozen_string_literal: true

describe Schematics::Associations::HasOne do
  subject(:association) do
    Schematics::Associations::Association.build(
      type: 'has_one',
      entity:,
      name: 'schema'
    )
  end

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

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }

  its(:type) { is_expected.to eq('has_one') }
  its(:name) { is_expected.to eq('entity') }
  its(:class_name) { is_expected.to eq('Entity') }
  its(:open_api_type) { is_expected.to eq(id!: String) }
  its(:weight) { is_expected.to eq(3) }
  its(:search_column) { is_expected.to eq(:entity_type) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:entity_i_cont) }
  its('descriptor.name') { is_expected.to eq('type') }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      entity: entity&.to_s
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_one :entity,
              -> { with_deleted },
              class_name: 'Entity',
              foreign_key: 'schema_id',
              inverse_of: :schema,
              autosave: true
    RUBY
  end

  context 'when association has a name collision' do
    before { association.prefixed = true }

    its(:name) { is_expected.to eq('schema_entity') }
  end
end
