# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Attributes::OneTimePassword do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'otp_secret' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Encryptable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Indexable) }
  it { is_expected.to be_encrypted }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('otp_secret') }
  its(:open_api_schema_type) { is_expected.to eq('string') }
  its(:default) { is_expected.to be_nil }
  its(:validators) { is_expected.to be_empty }
  its(:icon) { is_expected.to eq(:mobile_screen) }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.user.otp_secret') }

  its(:to_spec) do
    is_expected.to eq('A user has a **otp secret** attribute of type *one-time password*')
  end

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      encrypts :otp_secret, deterministic: true
      has_one_time_password column_name: :otp_secret,
                            after_column_name: :otp_last_at,
                            one_time_backup_codes: true
    RUBY
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class) }
  end
end
