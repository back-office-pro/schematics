# frozen_string_literal: true

describe Schematics::Attributes::String do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'last_name' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Normalizable) }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('last_name') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:input_name) { is_expected.to eq('user[last_name]') }
  its(:icon) { is_expected.to eq(:align_justify) }
  its(:default) { is_expected.to be_a(String) }
  its(:validators) { is_expected.to be_empty }
  its(:search_column) { is_expected.to eq(:last_name) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:last_name_i_cont) }
  its('validators.to_str') { is_expected.to be_blank }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.last_name') }
  its(:to_s) { is_expected.to eq('schema:user_last_name') }
  its(:to_spec) { is_expected.to eq('A user has a **last name** attribute of type *string*') }

  its(:available_options) do # rubocop:disable RSpec/ExampleLength
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

  context 'when string is unique' do
    let(:options) { { unique: true } }

    it { is_expected.to be_unique }

    its(:validators) do
      is_expected.to eq(uniqueness_with_deleted: { case_sensitive: true, allow_blank: true })
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :last_name, {:uniqueness_with_deleted=>{:case_sensitive=>true, :allow_blank=>true}}
      RUBY
    end
  end

  context 'when string is required' do
    let(:options) { { required: true } }

    it { is_expected.to be_required }
    its(:validators) { is_expected.to eq(presence: true) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :last_name, {:presence=>true}
      RUBY
    end
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::Text,
        Schematics::Attributes::Action,
        Schematics::Attributes::Address,
        Schematics::Attributes::Citext,
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
