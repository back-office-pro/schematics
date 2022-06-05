# frozen_string_literal: true

describe Schematics::Associations::HasAndBelongsToMany do
  subject(:association) { described_class.new(belongs_to:) }

  let(:entity) do
    Schematics::Entities::Entity.new(
      name: 'role',
      options: {
        descriptor: 'name'
      },
      attributes: [
        { name: 'name', type: 'string' }
      ]
    )
  end
  let(:options) do
    {
      inverse: {
        required: true,
        type: 'has_and_belongs_to_many'
      }
    }
  end
  let(:belongs_to) do
    Schematics::Attributes::BelongsTo.new(entity:, name: 'permission', options:)
  end

  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:type) { is_expected.to eq('has_and_belongs_to_many') }
  its(:name) { is_expected.to eq('permissions') }
  its(:column_name) { is_expected.to eq('permission_ids') }
  its(:default) { is_expected.to be_nil }
  its(:open_api_type) { is_expected.to eq([{ id!: String }]) }
  its(:permitted_params) { is_expected.to eq(permission_ids: []) }
  its(:weight) { is_expected.to eq(3) }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_and_belongs_to_many :permissions
    RUBY
  end
end
