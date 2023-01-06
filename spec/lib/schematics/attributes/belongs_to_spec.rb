# frozen_string_literal: true

describe Schematics::Attributes::BelongsTo do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:schema) { Schematics::Schema.new }
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
  let(:name) { 'user' }
  let(:options) do
    {
      inverse: {
        type: 'has_many'
      }
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Identifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:database_type) { is_expected.to eq('belongs_to') }
  its(:column_name) { is_expected.to eq('user_id') }
  its(:open_api_type) { is_expected.to eq(id!: String) }
  its(:association_type) { is_expected.to eq('user') }
  its(:inverse_association_name) { is_expected.to eq('entity') }
  its(:class_name) { is_expected.to eq('User') }
  its(:preload) { is_expected.to eq(:user) }
  its(:icon) { is_expected.to eq(:users) }
  its(:weight) { is_expected.to eq(2) }
  its(:inverse_association) { is_expected.to be_a(Schematics::Associations::HasMany) }
  its(:allowed_association_types) { is_expected.to include('user', 'role') }

  its(:available_options) do
    is_expected.to include(
      Schematics::Options::Inverse,
      Schematics::Options::Type,
      Schematics::Options::Polymorphic
    )
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      user: user&.to_s
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      belongs_to :user,
                 -> { with_deleted },
                 class_name: 'User',
                 foreign_key: 'user_id',
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
        belongs_to :user,
                   -> { with_deleted },
                   class_name: 'User',
                   foreign_key: 'user_id',
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
        belongs_to :user,
                   -> { with_deleted },
                   foreign_key: 'user_id',
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
