# frozen_string_literal: true

describe Schematics::Attributes::Ip do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'session') }
  let(:name) { 'ip' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('ip') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:default) { is_expected.to eq('::1') }
  its(:icon) { is_expected.to eq(:network_wired) }
  it { is_expected.to be_encrypted }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      encrypts :ip, deterministic: true
    RUBY
  end

  its(:validators) do
    is_expected.to eq(
      {
        allow_blank: true,
        format: { with: ::Resolv::AddressRegex, message: :ip_address }
      }
    )
  end
end
