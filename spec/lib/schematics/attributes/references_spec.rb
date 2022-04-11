# frozen_string_literal: true

describe Schematics::Attributes::References do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:parent_entity) do
    Schematics::Entities::Entity.build(
      name: 'user',
      descriptor: 'full_name',
      attributes: [
        { name: 'first_name', type: 'string' },
        { name: 'last_name', type: 'string' }
      ],
      virtuals: [
        {
          name: 'full_name',
          function: '$first_name $last_name'
        }
      ]
    )
  end
  let(:entity) do
    Schematics::Entities::Entity.build(
      name: 'entity',
      descriptor: 'type',
      attributes: [{ name: 'type', type: 'string' }]
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
  it { is_expected.not_to be_a(Schematics::Behaviours::Fillable) }

  its(:type) { is_expected.to eq('references') }
  its(:column_name) { is_expected.to eq('user_id') }
  its(:open_api_type) { is_expected.to eq(id!: String) }
  its(:association_type) { is_expected.to eq('user') }
  its(:inverse_association_name) { is_expected.to eq('entity') }
  its(:class_name) { is_expected.to eq('User') }
  its(:preload) { is_expected.to eq(:user) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:icon) { is_expected.to eq(:square_caret_right) }
  its(:weight) { is_expected.to eq(2) }
  its(:inverse_association) { is_expected.to be_a(Schematics::Associations::HasMany) }

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
                 polymorphic: false,
                 autosave: true,
                 counter_cache: :entities_count
    RUBY
  end

  context 'when references is required' do
    let(:options) do
      {
        required: true,
        inverse: {
          type: 'has_many'
        }
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
                   polymorphic: false,
                   autosave: true,
                   counter_cache: :entities_count
      RUBY
    end
  end

  context 'when references is polymorphic' do
    let(:options) do
      {
        polymorphic: true,
        inverse: {
          type: 'has_many'
        }
      }
    end

    its(:to_str) do
      is_expected.to eq <<~RUBY
        belongs_to :user,
                   -> { with_deleted },
                   class_name: 'User',
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
