# frozen_string_literal: true

describe Schematics::Attributes::Jsonb do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'user') }
  let(:name) { 'preferences' }
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
  it { is_expected.to be_a(Schematics::Behaviours::Translatable) }

  its(:icon) { is_expected.to eq(:table) }
  its(:database_type) { is_expected.to eq('jsonb') }
  its(:default) { is_expected.to be_empty }
  its(:column_name) { is_expected.to eq('preferences') }
  its(:open_api_body_type) { is_expected.to eq('object') }
  its(:open_api_schema_type) { is_expected.to eq('object') }
  its(:input_name) { is_expected.to eq('user[preferences]') }
  its(:validators) { is_expected.to be_empty }
  its('validators.to_str') { is_expected.to be_blank }
  its(:weight) { is_expected.to eq(1) }
  its(:permitted_params) { is_expected.to eq(preferences: {}) }
  its(:to_sql) { is_expected.to eq('users.preferences') }
  its(:to_s) { is_expected.to eq('preferences:jsonb:index') }
  its(:to_spec) { is_expected.to eq('A user has a **preferences** attribute of type *json*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.user.preferences') }
  its(:openai_description) { is_expected.to eq('An attribute which represents a JSON value') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::Translated
    )
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      jsonb: {
        type: 'object',
        additionalProperties: false,
        required: %w[name type options],
        properties: {
          type: {
            type: 'string',
            description: 'An attribute which represents a JSON value',
            enum: %w[jsonb]
          },
          name: { '$ref': '#/$defs/name' },
          options: {
            type: 'object',
            additionalProperties: false,
            anyOf: [
              { '$ref': '#/$defs/required' },
              { '$ref': '#/$defs/default' },
              { '$ref': '#/$defs/readonly' },
              { '$ref': '#/$defs/translated' }
            ]
          }
        }
      }
    )
  end

  context 'when there is a default' do
    let(:options) { { default: { theme: 'light', sidebar_toggled: false } } }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        attribute :preferences, default: -> { {"theme":"light","sidebar_toggled":false} }
      RUBY
    end
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class, Schematics::Attributes::Array) }
  end
end
