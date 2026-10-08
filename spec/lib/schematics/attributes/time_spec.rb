# frozen_string_literal: true

describe Schematics::Attributes::Time do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'message') }
  let(:name) { 'hour' }
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
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }

  its(:database_type) { is_expected.to eq('time') }
  its(:column_name) { is_expected.to eq('hour') }
  its(:open_api_body_type) { is_expected.to eq('datetime') }
  its(:open_api_schema_type) { is_expected.to eq('datetime') }
  its(:open_api_query_type) { is_expected.to eq('datetime') }
  its(:input_name) { is_expected.to eq('message[hour]') }
  its(:icon) { is_expected.to eq(:clock) }
  its(:validators) { is_expected.to be_empty }
  its('validators.to_str') { is_expected.to be_blank }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('messages.hour') }
  its(:to_s) { is_expected.to eq('hour:time:index') }
  its(:to_spec) { is_expected.to eq('A message has a **hour** attribute of type *time*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.message.hour') }
  its(:openai_description) { is_expected.to eq('An attribute which represents a time') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::GreaterThan,
      Schematics::Options::GreaterThanOrEqualTo,
      Schematics::Options::EqualTo,
      Schematics::Options::LessThan,
      Schematics::Options::LessThanOrEqualTo,
      Schematics::Options::OtherThan
    )
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      time: {
        type: 'object',
        additionalProperties: false,
        required: %w[name type options],
        properties: {
          type: {
            type: 'string',
            description: 'An attribute which represents a time',
            enum: %w[time]
          },
          name: { '$ref': '#/$defs/name' },
          options: {
            type: 'object',
            additionalProperties: false,
            anyOf: [
              { '$ref': '#/$defs/required' },
              { '$ref': '#/$defs/default' },
              { '$ref': '#/$defs/readonly' },
              { '$ref': '#/$defs/greater_than' },
              { '$ref': '#/$defs/greater_than_or_equal_to' },
              { '$ref': '#/$defs/equal_to' },
              { '$ref': '#/$defs/less_than' },
              { '$ref': '#/$defs/less_than_or_equal_to' },
              { '$ref': '#/$defs/other_than' }
            ]
          }
        }
      }
    )
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { Time.parse('2021/01/01 10:00 +0000').in_time_zone }

    it { is_expected.to eq('10:00') }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::Date,
        Schematics::Attributes::Datetime
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
