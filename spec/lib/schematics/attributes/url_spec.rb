# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Attributes::Url do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'url' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Indexable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Normalizable) }
  it { is_expected.to be_case_insensitive }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('url') }
  its(:open_api_body_type) { is_expected.to eq('string') }
  its(:open_api_schema_type) { is_expected.to eq('string') }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:input_name) { is_expected.to eq('user[url]') }
  its(:icon) { is_expected.to eq(:wifi) }
  its(:default) { is_expected.to match(URI::DEFAULT_PARSER.make_regexp) }
  its(:validators) { is_expected.to eq(url: { allow_blank: true }) }
  its(:search_column) { is_expected.to eq(:url) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:url_i_cont) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.url') }
  its(:to_s) { is_expected.to eq('url:string:index') }
  its(:to_spec) { is_expected.to eq('A user has a **url** attribute of type *url*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.user.url') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::Unique,
      Schematics::Options::Min,
      Schematics::Options::Limit,
      Schematics::Options::Length,
      Schematics::Options::Schemes
    )
  end

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :url, {:url=>{:allow_blank=>true}}
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      normalizes :url, with: -> { _1.strip.downcase.presence }
    RUBY
  end

  context 'when url is unique' do
    let(:options) { { unique: true } }

    it { is_expected.to be_unique }

    its(:to_s) { is_expected.to eq('url:string:uniq') }

    its(:validators) do
      is_expected.to eq(
        uniqueness_with_deleted: { case_sensitive: false, allow_blank: true },
        url: { allow_blank: true }
      )
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :url, {:uniqueness_with_deleted=>{:case_sensitive=>false, :allow_blank=>true}, :url=>{:allow_blank=>true}}
      RUBY
    end
  end

  context 'when url has schemes' do
    let(:options) { { schemes: ['https'] } }

    its(:default) { is_expected.to start_with('https') }
    its(:validators) { is_expected.to eq(url: { allow_blank: true, schemes: ['https'] }) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :url, {:url=>{:allow_blank=>true, :schemes=>["https"]}}
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

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::String,
        Schematics::Attributes::Text,
        Schematics::Attributes::Action,
        Schematics::Attributes::Address,
        Schematics::Attributes::Color,
        Schematics::Attributes::Country,
        Schematics::Attributes::Email,
        Schematics::Attributes::Ip,
        Schematics::Attributes::Locale,
        Schematics::Attributes::Mime,
        Schematics::Attributes::ModelField,
        Schematics::Attributes::Model,
        Schematics::Attributes::Phone,
        Schematics::Attributes::TimeZone,
        Schematics::Attributes::UserAgent,
        Schematics::Attributes::Code
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
