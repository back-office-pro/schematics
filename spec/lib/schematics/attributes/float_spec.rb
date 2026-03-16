# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Attributes::Float do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'entity') }
  let(:name) { 'weight' }
  let(:options) do
    {
      unit: 'kg'
    }
  end

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
  it { is_expected.to be_a(Schematics::Behaviours::Numerable) }
  it { is_expected.to be_a(Schematics::Behaviours::Incrementable) }
  it { is_expected.to be_a(Schematics::Behaviours::Duplicable) }

  its(:database_type) { is_expected.to eq('float') }
  its(:default) { is_expected.to be_zero }
  its(:column_name) { is_expected.to eq('weight') }
  its(:open_api_body_type) { is_expected.to eq('float') }
  its(:open_api_schema_type) { is_expected.to eq('float') }
  its(:open_api_query_type) { is_expected.to eq('float') }
  its(:input_name) { is_expected.to eq('entity[weight]') }
  its(:unit) { is_expected.to eq('kg') }
  its(:validators) { is_expected.to eq(numericality: { allow_blank: true }) }
  its(:icon) { is_expected.to eq(:arrow_up_1_9) } # rubocop:disable Naming/VariableNumber
  its(:to_spec) { is_expected.to eq('A entity has a **weight** attribute of type *float*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.entity.weight') }
  its(:openai_description) { is_expected.to eq('An attribute which represents a float number') }

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
      Schematics::Options::OtherThan,
      Schematics::Options::Unit,
      Schematics::Options::Precision,
      Schematics::Options::Separator,
      Schematics::Options::Delimiter,
      Schematics::Options::AutoIncrement
    )
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      float: {
        type: 'object',
        additionalProperties: false,
        required: %w[name type options],
        properties: {
          type: {
            type: 'string',
            description: 'An attribute which represents a float number',
            enum: %w[float]
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
              { '$ref': '#/$defs/other_than' },
              { '$ref': '#/$defs/auto_increment' },
              { '$ref': '#/$defs/unit' },
              { '$ref': '#/$defs/precision' },
              { '$ref': '#/$defs/separator' },
              { '$ref': '#/$defs/delimiter' }
            ]
          }
        }
      }
    )
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 100.099 }

    it { is_expected.to eq('100.099 kg') }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::Byte,
        Schematics::Attributes::Currency,
        Schematics::Attributes::Percentage,
        Schematics::Attributes::Rating
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
