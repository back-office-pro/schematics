require 'schematics/attributes/digest'

describe Schematics::Attributes::Digest do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) do
    Schematics::Entities::Entity.create(
      name: 'entity',
      descriptor: 'type',
      attributes: [{ name: 'type', type: 'string' }]
    )
  end
  let(:name) { 'password' }
  let(:options) { {} }

  it { is_expected.not_to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:type) { is_expected.to eq('digest') }
  its(:migration_options) { is_expected.to eq(%i[unique required default limit]) }
  its(:column_name) { is_expected.to eq('password') }
  its(:permitted_params) { is_expected.to eq(%w[password password_confirmation]) }
  its(:validators) { is_expected.to eq({ allow_nil: true }) }
  its(:icon) { is_expected.to eq(:key) }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_secure_password :password
    RUBY
  end
end
