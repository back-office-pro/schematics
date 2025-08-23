# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Attributes::String do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) do
    Schematics::Entities::Entity.new(
      name: 'user',
      options: {
        descriptor: 'full_name'
      },
      attributes: [
        { name: 'first_name', type: 'string' }
      ],
      virtuals: [
        { name: 'full_name', function: '$first_name $last_name' }
      ]
    )
  end
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
  it { is_expected.to be_a(Schematics::Behaviours::Normalizable) }
  it { is_expected.to be_valid }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('last_name') }
  its(:open_api_body_type) { is_expected.to eq('string') }
  its(:open_api_schema_type) { is_expected.to eq('string') }
  its(:open_api_query_type) { is_expected.to eq('string') }
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
  its(:to_s) { is_expected.to eq('last_name:string:index') }
  its(:to_spec) { is_expected.to eq('A user has a **last name** attribute of type *string*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.user.last_name') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::Translated,
      Schematics::Options::Unique,
      Schematics::Options::CaseInsensitive,
      Schematics::Options::Min,
      Schematics::Options::Limit,
      Schematics::Options::Length,
      Schematics::Options::Normalization
    )
  end

  context 'when string is unique' do
    let(:options) { { unique: true } }

    it { is_expected.to be_unique }

    its(:to_s) { is_expected.to eq('last_name:string:uniq') }

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

  context 'when attribute name is reserved' do
    let(:name) { 'slug' }

    it { is_expected.not_to be_valid }
  end

  context 'when attribute name is dangerous' do
    let(:name) { 'association' }

    it { is_expected.not_to be_valid }
  end

  context 'when attribute name is already taken by another attribute' do
    let(:name) { 'first_name' }

    it { is_expected.not_to be_valid }
  end

  context 'when attribute name is already taken by another virtual' do
    let(:name) { 'full_name' }

    it { is_expected.not_to be_valid }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
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
