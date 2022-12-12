# frozen_string_literal: true

describe Schematics::Attributes::Token do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'entity') }
  let(:name) { 'auth_token' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Encryptable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_encrypted }

  its(:database_type) { is_expected.to eq('token') }
  its(:column_name) { is_expected.to eq('auth_token') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:default) { is_expected.to be_a(String) }
  its(:validators) { is_expected.to be_empty }
  its(:icon) { is_expected.to eq(:key) }
  it { is_expected.to be_encrypted }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      encrypts :auth_token, deterministic: true
      has_secure_token :auth_token, length: 32
    RUBY
  end
end
