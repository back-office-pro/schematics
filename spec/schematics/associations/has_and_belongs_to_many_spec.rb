require 'schematics/associations/has_and_belongs_to_many'
require 'schematics/entities/entity'

describe Schematics::Associations::HasAndBelongsToMany do
  subject(:association) { described_class.new(belongs_to) }

  let(:entity) do
    Schematics::Entities::Entity.create(
      name: 'role',
      descriptor: 'name',
      attributes: [{ name: 'name', type: 'string' }]
    )
  end
  let(:options) do
    {
      "inverse": {
        "required": true,
        "type": 'has_and_belongs_to_many',
      },
    }
  end
  let(:belongs_to) do
    Schematics::Attributes::Attribute.create(
      entity,
      name: 'permission',
      type: 'belongs_to',
      options: options
    )
  end

  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:type) { is_expected.to eq('has_and_belongs_to_many') }
  its(:name) { is_expected.to eq('permissions') }
  its(:column_name) { is_expected.to eq('permission_ids') }
  its(:permitted_params) { is_expected.to eq({ permission_ids: [] }) }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_and_belongs_to_many :permissions
    RUBY
  end

  its(:generator) do
    is_expected.to eq <<~SHELL
      rails g migration create_join_table_roles_permissions roles permissions:join_table_uuid
    SHELL
  end
end
