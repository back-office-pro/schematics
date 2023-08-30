# frozen_string_literal: true

describe Schematics::Associations::HasAndBelongsToMany do
  subject(:association) do
    Schematics::Associations::Association.build(
      type: 'has_and_belongs_to_many',
      entity:,
      name: 'permissions'
    )
  end

  let(:schema) { Schematics::Schema.new }
  let(:entity) do
    Schematics::Entities::Entity.new(
      schema:,
      name: 'role',
      options: {
        descriptor: 'name'
      },
      attributes: [
        { name: 'name', type: 'string' }
      ]
    )
  end

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:type) { is_expected.to eq('has_and_belongs_to_many') }
  its(:name) { is_expected.to eq('permissions') }
  its(:column_name) { is_expected.to eq('permission_ids') }
  its(:class_name) { is_expected.to eq('Permission') }
  its(:open_api_type) { is_expected.to eq([{ id!: String }]) }
  its(:permitted_params) { is_expected.to eq(permission_ids: []) }
  its(:allowed_association_types) { is_expected.to include('user', 'role') }
  its(:icon) { is_expected.to eq(:lock) }
  its(:weight) { is_expected.to eq(3) }

  its(:available_options) do # rubocop:disable RSpec/ExampleLength
    is_expected.to contain_exactly(
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Type,
      Schematics::Options::GroupBy
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      scope :with_permissions, -> { includes([:permissions]) }
      has_and_belongs_to_many :permissions, class_name: 'Permission'
    RUBY
  end
end
