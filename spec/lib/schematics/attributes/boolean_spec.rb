# frozen_string_literal: true

describe Schematics::Attributes::Boolean do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'entity') }
  let(:name) { 'toggle' }
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
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:database_type) { is_expected.to eq('boolean') }
  its(:default) { is_expected.to be_falsy }
  its(:column_name) { is_expected.to eq('toggle') }
  its(:open_api_body_type) { is_expected.to eq('boolean') }
  its(:open_api_schema_type) { is_expected.to eq('boolean') }
  its(:open_api_query_type) { is_expected.to eq('boolean') }
  its(:input_name) { is_expected.to eq('entity[toggle]') }
  its(:icon) { is_expected.to eq(:toggle_on) }
  its(:search_column) { is_expected.to eq(:toggle) }
  its(:search_predicate) { is_expected.to eq(:true) }
  its(:search_query) { is_expected.to eq(:toggle_true) }
  its(:to_spec) { is_expected.to eq('A entity has a **toggle** attribute of type *boolean*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.entity.toggle') }
  its(:openai_description) { is_expected.to eq('An attribute which represents a boolean') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::Acceptance
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      attribute :toggle, default: -> { false }
    RUBY
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      boolean: {
        type: 'object',
        additionalProperties: false,
        required: %w[name type options],
        properties: {
          type: {
            type: 'string',
            description: 'An attribute which represents a boolean',
            enum: %w[boolean]
          },
          name: { '$ref': '#/$defs/name' },
          options: {
            type: 'object',
            additionalProperties: false,
            anyOf: [
              { '$ref': '#/$defs/required' },
              { '$ref': '#/$defs/default' },
              { '$ref': '#/$defs/readonly' },
              { '$ref': '#/$defs/acceptance' }
            ]
          }
        }
      }
    )
  end

  context 'when true is the default value' do
    let(:options) { { default: true } }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        attribute :toggle, default: -> { true }
      RUBY
    end
  end

  context 'when false is the default value' do
    let(:options) { { default: false } }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        attribute :toggle, default: -> { false }
      RUBY
    end
  end

  context 'when boolean must be accepted' do
    let(:options) { { acceptance: true } }

    its(:validators) { is_expected.to eq(acceptance: true) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :toggle, {acceptance: true}
      RUBY
    end
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 'true' }

    it { is_expected.to eq('TRUE') }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class) }
  end
end
