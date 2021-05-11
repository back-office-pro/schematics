require 'schematics/attributes/digest'
require 'schematics/entities/entity'

describe Schematics::Attributes::Digest do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.create(name: 'entity') }
  let(:name) { 'password' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:type) { is_expected.to eq('digest') }
  its(:column_name) { is_expected.to eq('password') }
  its(:permitted_params) { is_expected.to eq(%i[password password_confirmation]) }
  its(:validators) { is_expected.to eq({ allow_nil: true }) }
  its(:icon) { is_expected.to eq(:key) }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_secure_password :password
    RUBY
  end
end
