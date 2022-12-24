# frozen_string_literal: true

describe Schematics::Attributes::BelongsTo do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:schema) { Schematics::Schema.new }
  let(:parent_entity) do
    Schematics::Entities::Entity.new(
      schema:,
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
  let(:name) { 'schema' }
  let(:options) { {} }

  before do
    attribute.inverse_entity = parent_entity
  end

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:database_type) { is_expected.to eq('belongs_to') }
  its(:column_name) { is_expected.to eq('schema_id') }
  its(:open_api_type) { is_expected.to eq(id!: String) }
  its(:association_type) { is_expected.to eq('schema') }
  its(:inverse_association_name) { is_expected.to eq('entity') }
  its(:class_name) { is_expected.to eq('Schema') }
  its(:model_class) { is_expected.to be_nil }
  its(:preload) { is_expected.to eq(:schema) }
  its(:icon) { is_expected.to eq(:square_caret_right) }
  its(:to_sql) { is_expected.to eq('schemas.title') }
  its(:weight) { is_expected.to eq(2) }
  its(:inverse_association) { is_expected.to be_a(Schematics::Associations::HasMany) }
  its(:allowed_association_types) { is_expected.to include('user', 'role') }
  its(:search_column) { is_expected.to eq(:schema_title) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:schema_i_cont) }

  its(:available_options) do
    is_expected.to include(
      Schematics::Options::Inverse,
      Schematics::Options::Type,
      Schematics::Options::Polymorphic
    )
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      schema: schema&.to_s
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      belongs_to :schema,
                 -> { with_deleted },
                 class_name: 'Schema',
                 foreign_key: 'schema_id',
                 inverse_of: :entities,
                 optional: true,
                 autosave: true,
                 counter_cache: :entities_count
    RUBY
  end

  context 'when belongs_to is required' do
    let(:options) do
      {
        required: true
      }
    end

    its(:to_str) do
      is_expected.to eq <<~RUBY
        belongs_to :schema,
                   -> { with_deleted },
                   class_name: 'Schema',
                   foreign_key: 'schema_id',
                   inverse_of: :entities,
                   optional: false,
                   autosave: true,
                   counter_cache: :entities_count
      RUBY
    end
  end

  context 'when belongs_to is polymorphic' do
    let(:options) do
      {
        polymorphic: true
      }
    end

    its(:to_str) do
      is_expected.to eq <<~RUBY
        belongs_to :schema,
                   -> { with_deleted },
                   foreign_key: 'schema_id',
                   inverse_of: :entities,
                   optional: true,
                   polymorphic: true,
                   autosave: true,
                   counter_cache: :entities_count
      RUBY
    end
  end

  context 'when inverse association is has_one' do
    let(:options) do
      {
        inverse: {
          type: 'has_one'
        }
      }
    end

    its(:inverse_association) { is_expected.to be_a(Schematics::Associations::HasOne) }
  end
end
