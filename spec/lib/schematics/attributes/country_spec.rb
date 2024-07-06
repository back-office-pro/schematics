# frozen_string_literal: true

describe Schematics::Attributes::Country do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'country' }
  let(:options) { {} }

  before do
    allow(ISO3166::Country).to receive(:codes).and_return(['FR'])
  end

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Enumerable) }
  it { is_expected.to be_a(Schematics::Behaviours::Unnormalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Untranslatable) }
  it { is_expected.not_to be_translated }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('country') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:open_api_filter_type) { is_expected.to eq(String) }
  its(:input_name) { is_expected.to eq('user[country]') }
  its(:icon) { is_expected.to eq(:earth_europe) }
  its(:default) { is_expected.to eq('FR') }
  its(:validators) { is_expected.to eq(inclusion: { in: ['FR'] }, allow_blank: true) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.country') }
  its(:to_s) { is_expected.to eq('schema:user_country') }
  its(:collection) { is_expected.to eq([%w[France FR]]) }
  its(:search_column) { is_expected.to eq(:country) }
  its(:search_predicate) { is_expected.to eq(:in) }
  its(:search_query) { is_expected.to eq(:country_in) }
  its(:normalization) { is_expected.to be_nil }
  its(:to_spec) { is_expected.to eq('A user has a **country** attribute of type *country*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.user.country') }

  its(:available_options) do # rubocop:disable RSpec/ExampleLength
    is_expected.to contain_exactly(
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::Unique
    )
  end

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :country, {:inclusion=>{:in=>["FR"]}, :allow_blank=>true}
    RUBY
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      country: country&.to_s
    RUBY
  end

  context 'when country is required' do
    let(:options) { { required: true } }

    its(:collection) { is_expected.to eq([%w[France FR]]) }
    its(:validators) { is_expected.to eq(inclusion: { in: ['FR'] }, presence: true) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :country, {:presence=>true, :inclusion=>{:in=>["FR"]}}
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
        Schematics::Attributes::Citext,
        Schematics::Attributes::Color,
        Schematics::Attributes::Email,
        Schematics::Attributes::Ip,
        Schematics::Attributes::Locale,
        Schematics::Attributes::Mime,
        Schematics::Attributes::ModelField,
        Schematics::Attributes::Model,
        Schematics::Attributes::Phone,
        Schematics::Attributes::TimeZone,
        Schematics::Attributes::UserAgent,
        Schematics::Attributes::Url,
        Schematics::Attributes::Code
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
