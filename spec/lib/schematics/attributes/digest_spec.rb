# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Attributes::Digest do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'entity') }
  let(:name) { 'password' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Indexable) }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('password_digest') }
  its(:open_api_body_type) { is_expected.to eq('password') }
  its(:open_api_schema_type) { is_expected.to eq('password') }
  its(:input_name) { is_expected.to eq('entity[password_digest]') }
  its(:default) { is_expected.to eq('Azerty1234?!!') }
  its(:permitted_params) { is_expected.to eq(%i[password password_confirmation]) }
  its(:icon) { is_expected.to eq(:key) }
  its(:to_spec) { is_expected.to eq('A entity has a **password** attribute of type *password*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.entity.password') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::Confirm,
      Schematics::Options::Min
    )
  end

  its(:validators) do
    is_expected.to eq(
      {
        allow_blank: true,
        not_pwned: { on_error: :valid },
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
          not_pwned: { on_error: :valid },
          confirmation: { allow_blank: true },
          format: { with: described_class::REGEX, message: :password },
          length: { maximum: 72 }
        }
      )
    end
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class) }
  end
end
