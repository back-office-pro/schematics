require 'schematics/associations/has_one'

describe Schematics::Associations::HasOne do
  subject(:association) { described_class.new(belongs_to) }

  let(:parent_entity) do
    Schematics::Entities::Entity.create(
      name: 'schema',
      descriptor: 'title',
      attributes: [{ name: 'title', type: 'string' }]
    )
  end
  let(:entity) do
    Schematics::Entities::Entity.create(
      name: 'entity',
      descriptor: 'type',
      attributes: [{ name: 'type', type: 'string' }]
    )
  end
  let(:options) do
    {
      "inverse": {
        "type": 'has_one',
      },
    }
  end
  let(:belongs_to) do
    Schematics::Attributes::Attribute.create(
      entity,
      name: 'schema',
      type: 'belongs_to',
      options: options
    )
  end

  before do
    belongs_to.inverse_descriptor = parent_entity.descriptor
  end

  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }

  its(:type) { is_expected.to eq('has_one') }
  its(:name) { is_expected.to eq('entity') }
  its(:class_name) { is_expected.to eq('Entity') }
  its('descriptor.name') { is_expected.to eq('type') }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      entity&.type&.searchize
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_one :entity,
              class_name: 'Entity',
              foreign_key: 'schema_id'
    RUBY
  end
end
