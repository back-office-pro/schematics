# frozen_string_literal: true

describe Schematics::Attributes::Url do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'url' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Encryptable) }

  its(:database_type) { is_expected.to eq('citext') }
  its(:column_name) { is_expected.to eq('url') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:icon) { is_expected.to eq(:wifi) }
  its(:default) { is_expected.to match(URI::DEFAULT_PARSER.make_regexp) }
  its(:validators) { is_expected.to eq(url: { allow_blank: true }) }
  its(:search_column) { is_expected.to eq(:url) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:url_i_cont) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.url') }
  its(:to_s) { is_expected.to eq('schema:user_url') }
  it { is_expected.to be_encrypted }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      encrypts :url, deterministic: true
    RUBY
  end

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :url, {:url=>{:allow_blank=>true}}
    RUBY
  end

  context 'when url is unique' do
    let(:options) { { unique: true } }

    it { is_expected.to be_unique }

    its(:validators) do
      is_expected.to eq(
        uniqueness: { case_sensitive: false, allow_blank: true },
        url: { allow_blank: true }
      )
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :url, {:uniqueness=>{:case_sensitive=>false, :allow_blank=>true}, :url=>{:allow_blank=>true}}
      RUBY
    end
  end

  context 'when url is required' do
    let(:options) { { required: true } }

    it { is_expected.to be_required }
    its(:validators) { is_expected.to eq(presence: true, url: { allow_blank: false }) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :url, {:presence=>true, :url=>{:allow_blank=>false}}
      RUBY
    end
  end
end
