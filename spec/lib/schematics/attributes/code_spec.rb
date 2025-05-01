# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Attributes::Code do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'template') }
  let(:name) { 'content' }
  let(:options) do
    {
      limit: 100
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Multisearchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Translatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Unnormalizable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Indexable) }

  its(:database_type) { is_expected.to eq('text') }
  its(:column_name) { is_expected.to eq('content') }
  its(:open_api_body_type) { is_expected.to eq('string') }
  its(:open_api_schema_type) { is_expected.to eq('string') }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:input_name) { is_expected.to eq('template[content]') }
  its(:icon) { is_expected.to eq(:code) }
  its(:default) { is_expected.to be_a(String) }
  its(:search_column) { is_expected.to eq(:content) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:content_i_cont) }
  its(:preload) { is_expected.to be_empty }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.template.content') }

  its(:to_spec) do
    is_expected.to eq('A template has a **content** attribute of type *code editor*')
  end

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::Translated,
      Schematics::Options::Min,
      Schematics::Options::Limit,
      Schematics::Options::Length,
      Schematics::Options::Language
    )
  end

  context 'when hidden' do
    let(:options) { { hidden: true } }

    it { is_expected.to be_hidden }
  end

  context 'when readonly' do
    let(:options) { { readonly: true } }

    it { is_expected.to be_readonly }
  end

  context 'when there is a default value' do
    let(:options) { { default: 'text' } }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        attribute :content, default: -> { "text" }
        normalizes :content, with: -> { _1.strip.itself.presence }
      RUBY
    end
  end

  context 'when translated' do
    let(:options) { { translated: true } }

    its(:permitted_params) { is_expected.to eq(%i[content content_en content_fr content_it]) }
    its(:preload) { is_expected.to eq([:text_translations]) }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        translates :content, type: :text
        normalizes :content, with: -> { _1.strip.itself.presence }
      RUBY
    end
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::Text,
        Schematics::Attributes::String,
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
        Schematics::Attributes::Url
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
