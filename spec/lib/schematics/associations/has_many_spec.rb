# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Associations::HasMany do
  subject(:association) do
    Schematics::Associations::Association.build(
      type: 'has_many',
      entity:,
      name: 'schema',
      options:
    )
  end

  let(:data) do
    [
      {
        name: 'entity',
        options: {
          descriptor: 'type'
        },
        attributes: [
          { name: 'type', type: 'string' }
        ]
      },
      {
        name: 'schema'
      }
    ]
  end
  let(:schema) { Schematics::Schema.new(data:) }
  let(:entity) { Schematics::Entities::Entity.new(schema:, **data.first) }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }

  its(:type) { is_expected.to eq('has_many') }
  its(:name) { is_expected.to eq('entities') }
  its(:class_name) { is_expected.to eq('Default::Entity') }
  its(:column_name) { is_expected.to eq('schema_id') }
  its(:inverse_of) { is_expected.to eq('schema') }
  its(:open_api_schema_type) { is_expected.to eq([id: 'string', type: 'string']) }
  its(:weight) { is_expected.to eq(3) }
  its(:to_spec) { is_expected.to eq('A schema has many **entities**') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.entity.entities') }
  its('descriptor.name') { is_expected.to eq('type') }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      scope :with_entities, -> { includes([:entities]) }
      has_many :entities,
              -> { with_deleted },
              class_name: 'Default::Entity',
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

    it { is_expected.to be_required }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        scope :with_entities, -> { includes([:entities]) }
        has_many :entities,
                -> { with_deleted },
                class_name: 'Default::Entity',
                foreign_key: 'schema_id',
                inverse_of: :schema,
                dependent: :destroy
      RUBY
    end
  end
end
