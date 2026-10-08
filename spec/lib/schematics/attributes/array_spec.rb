# frozen_string_literal: true

describe Schematics::Attributes::Array do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'comparison') }
  let(:name) { 'ids' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Generatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Indexable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Encryptable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Translatable) }

  its(:icon) { is_expected.to eq(:list) }
  its(:database_type) { is_expected.to eq('jsonb') }
  its(:column_name) { is_expected.to eq('ids') }
  its(:open_api_body_type) { is_expected.to eq(['string']) }
  its(:open_api_schema_type) { is_expected.to eq(['string']) }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:validators) { is_expected.to be_empty }
  its('validators.to_str') { is_expected.to be_blank }
  its(:weight) { is_expected.to eq(1) }
  its(:default) { is_expected.to be_all(String) }
  its(:permitted_params) { is_expected.to eq(ids: []) }
  its(:input_name) { is_expected.to eq('comparison[ids][]') }
  its(:to_sql) { is_expected.to eq('comparisons.ids') }
  its(:to_s) { is_expected.to eq('ids:jsonb:index') }
  its(:search_column) { is_expected.to eq(:ids) }
  its(:search_predicate) { is_expected.to eq(:any) }
  its(:search_query) { is_expected.to eq(:ids_any) }
  its(:to_spec) { is_expected.to eq('A comparison has a **ids** attribute of type *array*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.comparison.ids') }
  its(:openai_description) { is_expected.to eq('An attribute which represents an array of values') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::Encrypted,
      Schematics::Options::Translated
    )
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      array: {
        type: 'object',
        additionalProperties: false,
        required: %w[name type options],
        properties: {
          type: {
            type: 'string',
            description: 'An attribute which represents an array of values',
            enum: %w[array]
          },
          name: { '$ref': '#/$defs/name' },
          options: {
            type: 'object',
            anyOf: [
              { '$ref': '#/$defs/required' },
              { '$ref': '#/$defs/default' },
              { '$ref': '#/$defs/readonly' },
              { '$ref': '#/$defs/translated' }
            ],
            additionalProperties: false
          }
        }
      }
    )
  end

  describe '#format' do
    subject { attribute.format(values) }

    let(:values) { %w[foo bar] }

    it { is_expected.to eq('foo, bar') }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class, Schematics::Attributes::Jsonb) }
  end
end
