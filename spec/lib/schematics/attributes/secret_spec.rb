# frozen_string_literal: true

describe Schematics::Attributes::Secret do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'entity') }
  let(:name) { 'gcloud_public_api_key' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Generatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Encryptable) }
  it { is_expected.to be_a(Schematics::Behaviours::Normalizable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Indexable) }
  it { is_expected.to be_encrypted }
  it { is_expected.to be_valid }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('gcloud_public_api_key') }
  its(:open_api_body_type) { is_expected.to eq('string') }
  its(:open_api_schema_type) { is_expected.to eq('string') }
  its(:validators) { is_expected.to be_empty }
  its('validators.to_str') { is_expected.to be_blank }
  its(:default) { is_expected.to be_a(String) }
  its(:icon) { is_expected.to eq(:user_secret) }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.entity.gcloud_public_api_key') }
  its(:openai_description) { is_expected.to eq('An attribute which represents a secret') }

  its(:to_spec) do
    is_expected.to eq('A entity has a **gcloud public api key** attribute of type *secret*')
  end

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Group,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::Normalization
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      encrypts :gcloud_public_api_key, deterministic: true
      normalizes :gcloud_public_api_key, with: -> { it.strip.itself.presence }
    RUBY
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      secret: {
        type: 'object',
        additionalProperties: false,
        required: %w[name type options],
        properties: {
          type: {
            type: 'string',
            description: 'An attribute which represents a secret',
            enum: %w[secret]
          },
          name: { '$ref': '#/$defs/name' },
          options: {
            type: 'object',
            additionalProperties: false,
            anyOf: [
              { '$ref': '#/$defs/required' },
              { '$ref': '#/$defs/default' },
              { '$ref': '#/$defs/readonly' },
              { '$ref': '#/$defs/normalization' }
            ]
          }
        }
      }
    )
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class) }
  end
end
