# frozen_string_literal: true

describe Schematics::Attributes::Digest do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'entity') }
  let(:name) { 'password' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:database_type) { is_expected.to eq('digest') }
  its(:column_name) { is_expected.to eq('password') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:default) { is_expected.to eq('Azerty1!') }
  its(:permitted_params) { is_expected.to eq(%i[password password_confirmation]) }
  its(:icon) { is_expected.to eq(:key) }
  its(:available_options) { is_expected.to include(:confirm, :min, :default) }

  its(:validators) do
    is_expected.to eq(
      {
        allow_blank: true,
        format: { with: described_class::REGEX, message: :password },
        length: { maximum: 72 }
      }
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_secure_password :password, validations: false
    RUBY
  end

  context 'when digest needs to be confirmed' do
    let(:options) { { confirm: true } }

    it { is_expected.to be_confirm }

    its(:validators) do
      is_expected.to eq(
        {
          allow_blank: true,
          confirmation: { allow_blank: true },
          format: { with: described_class::REGEX, message: :password },
          length: { maximum: 72 }
        }
      )
    end
  end
end
