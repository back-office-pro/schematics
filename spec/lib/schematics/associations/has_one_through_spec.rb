# frozen_string_literal: true

describe Schematics::Associations::HasOneThrough do
  subject(:association) { described_class.new(belongs_to:, through:) }

  let(:schema) { Schematics::Schema.new }
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
    Schematics::Attributes::BelongsTo.new(entity: through_entity, name: 'user')
  end
  let(:through) do
    Schematics::Attributes::BelongsTo.new(entity:, name: 'entity')
  end

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }

  its(:type) { is_expected.to eq('has_one') }
  its(:name) { is_expected.to eq('user') }
  its(:class_name) { is_expected.to eq('User') }
  its(:open_api_type) { is_expected.to eq(id!: String) }
  its(:weight) { is_expected.to eq(3) }
  its('descriptor.name') { is_expected.to eq('full_name') }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      user: user&.to_s
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_one :user,
              class_name: 'User',
              foreign_key: 'user_id',
              through: :entity,
              source: :user,
              autosave: true
    RUBY
  end

  context 'when association has a name collision' do
    before { association.prefixed = true }

    its(:name) { is_expected.to eq('entity_user') }
  end
end
