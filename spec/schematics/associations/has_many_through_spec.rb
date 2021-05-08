require 'schematics/associations/has_many_through'
require 'schematics/entities/entity'

describe Schematics::Associations::HasManyThrough do
  subject(:association) { described_class.new(through, belongs_to.inverse_association) }

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
    Schematics::Attributes::Attribute.create(
      through_entity,
      name: 'schema',
      type: 'belongs_to'
    )
  end
  let(:through) do
    Schematics::Attributes::Attribute.create(
      entity,
      name: 'entity',
      type: 'belongs_to'
    )
  end

  before do
    belongs_to.inverse_entity = parent_entity
    through.inverse_entity = through_entity
  end

  its(:type) { is_expected.to eq('has_many') }
  its(:name) { is_expected.to eq('attributes') }
  its(:class_name) { is_expected.to eq('Attribute') }
  its('descriptor.name') { is_expected.to eq('name') }

  its('to_str.squish') do
    is_expected.to eq <<~RUBY.squish
      has_many :attributes,
               class_name: 'Attribute',
               foreign_key: 'entity_id',
               through: :entities,
               source: :attributes
    RUBY
  end

  context 'when association has a name collision' do
    before { association.prefixed = true }

    its(:name) { is_expected.to eq('entity_attributes') }
  end
end
