# frozen_string_literal: true

require 'schematics/attributes/belongs_to'
require 'schematics/entities/entity'

describe Schematics::Attributes::BelongsTo do
  subject(:attribute) { described_class.new(entity, name, options) }

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
  let(:name) { 'schema' }
  let(:options) { {} }

  before do
    attribute.inverse_entity = parent_entity
  end

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Editable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:type) { is_expected.to eq('belongs_to') }
  its(:column_name) { is_expected.to eq('schema_id') }
  its(:association_type) { is_expected.to eq('schema') }
  its(:inverse_association_name) { is_expected.to eq('entity') }
  its(:preload) { is_expected.to eq(:schema) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:icon) { is_expected.to eq(:caret_square_right) }
  its(:inverse_association) { is_expected.to be_a(Schematics::Associations::HasMany) }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      schema&.title&.parameterize(separator: ' ')
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      belongs_to :schema,
                 class_name: 'Schema',
                 foreign_key: 'schema_id',
                 inverse_of: :entities,
                 optional: true,
                 counter_cache: :entities_count
    RUBY
  end

  context 'when belongs_to is required' do
    let(:options) do
      {
        required: true,
      }
    end

    its(:to_str) do
      is_expected.to eq <<~RUBY
        belongs_to :schema,
                   class_name: 'Schema',
                   foreign_key: 'schema_id',
                   inverse_of: :entities,
                   optional: false,
                   counter_cache: :entities_count
      RUBY
    end
  end

  context 'when inverse association is has_one' do
    let(:options) do
      {
        inverse: {
          type: 'has_one',
        },
      }
    end

    its(:inverse_association) { is_expected.to be_a(Schematics::Associations::HasOne) }
  end
end
