# frozen_string_literal: true

describe Schematics::Attributes::Digest do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'entity') }
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
  its(:default) { is_expected.to eq('Azerty1!') }
  its(:permitted_params) { is_expected.to eq(%i[password password_confirmation]) }
  its(:icon) { is_expected.to eq(:key) }

  its(:validators) do
    is_expected.to eq(
      {
        allow_nil: true,
        format: { with: described_class::REGEX, message: :password }
      }
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_secure_password :password
    RUBY
  end
end
