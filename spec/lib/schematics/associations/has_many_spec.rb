# frozen_string_literal: true

describe Schematics::Associations::HasMany do
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
  let(:belongs_to) do
    Schematics::Attributes::Attribute.create(
      entity,
      name: 'schema',
      type: 'belongs_to',
      options: options
    )
  end
  let(:options) { {} }

  before do
    belongs_to.inverse_entity = parent_entity
  end

  its(:type) { is_expected.to eq('has_many') }
  its(:name) { is_expected.to eq('entities') }
  its(:class_name) { is_expected.to eq('Entity') }
  its('descriptor.name') { is_expected.to eq('type') }

  its('to_str.squish') do
    is_expected.to eq <<~RUBY.squish
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

    its('to_str.squish') do
      is_expected.to eq <<~RUBY.squish
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
