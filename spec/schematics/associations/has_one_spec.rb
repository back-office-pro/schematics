# frozen_string_literal: true

require 'schematics/associations/has_one'
require 'schematics/entities/entity'

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
      inverse: {
        type: 'has_one',
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
    belongs_to.inverse_entity = parent_entity
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
      entity&.type&.parameterize(separator: ' ')
    RUBY
  end

  its('to_str.squish') do
    is_expected.to eq <<~RUBY.squish
      has_one :entity,
              class_name: 'Entity',
              foreign_key: 'schema_id',
              inverse_of: :schema
    RUBY
  end

  context 'when association has a name collision' do
    before { association.prefixed = true }

    its(:name) { is_expected.to eq('schema_entity') }
  end
end
