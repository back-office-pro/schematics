# frozen_string_literal: true

describe Schematics::Attributes::Token do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'entity') }
  let(:name) { 'auth_token' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Editable) }
  it { is_expected.to be_unique }
  it { is_expected.to be_case_sensitive }

  its(:type) { is_expected.to eq('token') }
  its(:column_name) { is_expected.to eq('auth_token') }
  its(:open_api_type) { is_expected.to eq('string') }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_secure_token :auth_token
    RUBY
  end
end
