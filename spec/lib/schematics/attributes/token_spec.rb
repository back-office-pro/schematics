# frozen_string_literal: true

describe Schematics::Attributes::Token do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'entity') }
  let(:name) { 'auth_token' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Encryptable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Indexable) }
  it { is_expected.to be_encrypted }
  it { is_expected.to be_unique }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('auth_token') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:default) { is_expected.to be_a(String) }
  its(:icon) { is_expected.to eq(:key) }
  its(:to_spec) { is_expected.to eq('A entity has a **auth token** attribute of type *token*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.entity.auth_token') }

  its(:validators) do
    is_expected.to eq(uniqueness_with_deleted: { case_sensitive: true, allow_blank: true })
  end

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :auth_token, {:uniqueness_with_deleted=>{:case_sensitive=>true, :allow_blank=>true}}
    RUBY
  end

  its(:available_options) do # rubocop:disable RSpec/ExampleLength
    is_expected.to contain_exactly(
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Encrypted
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      encrypts :auth_token, deterministic: true
      has_secure_token :auth_token, length: 32
    RUBY
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class) }
  end
end
