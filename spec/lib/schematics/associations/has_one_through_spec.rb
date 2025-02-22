# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Associations::HasOneThrough do
  subject(:association) { described_class.new(belongs_to:, through:) }

  let(:schema) { Schematics::Schema.new(name: 'demo') }
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

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }

  its(:type) { is_expected.to eq('has_one') }
  its(:name) { is_expected.to eq('user') }
  its(:class_name) { is_expected.to eq('User') }
  its(:column_name) { is_expected.to eq('user_id') }
  its(:source) { is_expected.to eq('user') }
  its(:open_api_schema_type) { is_expected.to eq(id: 'string', full_name: 'string') }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:weight) { is_expected.to eq(3) }
  its(:search_column) { is_expected.to eq(:user_full_name) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:user_i_cont) }
  its(:to_spec) { is_expected.to eq('A attribute has one **user** through **entity**') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.entity.user') }
  its('descriptor.name') { is_expected.to eq('full_name') }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      scope :with_user, -> { includes([{user: :string_translations}]) }
      has_one :user,
              -> { with_deleted },
              class_name: 'User',
              foreign_key: 'user_id',
              through: :entity,
              source: :user,
              autosave: true
    RUBY
  end
end
