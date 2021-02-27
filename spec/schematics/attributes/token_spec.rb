require 'schematics/attributes/token'

describe Schematics::Attributes::Token do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) do
    Schematics::Entities::Entity.create(
      name: 'entity',
      descriptor: 'type',
      attributes: [{ name: 'type', type: 'string' }]
    )
  end
  let(:name) { 'auth_token' }
  let(:options) { {} }

  it { is_expected.not_to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Editable) }

  its(:type) { is_expected.to eq('token') }
  its(:column_name) { is_expected.to eq('auth_token') }
  its(:api_param_type) { is_expected.to eq('string') }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_secure_token :auth_token
    RUBY
  end
end
