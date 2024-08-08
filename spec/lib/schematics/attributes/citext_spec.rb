# frozen_string_literal: true

describe Schematics::Attributes::Citext do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'last_name' }
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
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Translatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Normalizable) }
  it { is_expected.not_to be_case_sensitive }

  its(:database_type) { is_expected.to eq('citext') }
  its(:column_name) { is_expected.to eq('last_name') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:open_api_filter_type) { is_expected.to eq(String) }
  its(:input_name) { is_expected.to eq('user[last_name]') }
  its(:icon) { is_expected.to eq(:align_justify) }
  its(:default) { is_expected.to be_a(String) }
  its(:validators) { is_expected.to be_empty }
  its('validators.to_str') { is_expected.to be_blank }
  its(:search_column) { is_expected.to eq(:last_name) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:last_name_i_cont) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.last_name') }
  its(:to_s) { is_expected.to eq('schema:user_last_name') }
  its(:preload) { is_expected.to be_empty }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.user.last_name') }

  its(:to_spec) do
    is_expected.to eq('A user has a **last name** attribute of type *case insensitive text*')
  end

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::Translated,
      Schematics::Options::Unique,
      Schematics::Options::Min,
      Schematics::Options::Limit,
      Schematics::Options::Length,
      Schematics::Options::Normalization
    )
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      last_name: last_name&.to_s
    RUBY
  end

  context 'when attribute is unique' do
    let(:options) { { unique: true } }

    it { is_expected.to be_unique }

    its(:validators) do
      is_expected.to eq(uniqueness_with_deleted: { case_sensitive: false, allow_blank: true })
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :last_name, {:uniqueness_with_deleted=>{:case_sensitive=>false, :allow_blank=>true}}
      RUBY
    end
  end

  context 'when attribute is required' do
    let(:options) { { required: true } }

    it { is_expected.to be_required }
    its(:validators) { is_expected.to eq(presence: true) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :last_name, {:presence=>true}
      RUBY
    end
  end

  context 'when attribute is translated' do
    let(:options) { { translated: true } }

    its(:permitted_params) do
      is_expected.to eq(%i[last_name last_name_en last_name_fr last_name_it])
    end

    its(:preload) { is_expected.to eq([:string_translations]) }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        translates :last_name, type: :string
        normalizes :last_name, with: -> { _1.strip.itself.presence }
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
        Schematics::Attributes::Url,
        Schematics::Attributes::Code
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
