# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Attributes::Enum do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'product') }
  let(:name) { 'state' }
  let(:options) { { values: %w[available available_soon not_available] } }

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
  it { is_expected.to be_a(Schematics::Behaviours::Enumerable) }

  its(:database_type) { is_expected.to eq('integer') }
  its(:column_name) { is_expected.to eq('state') }
  its(:open_api_body_type) { is_expected.to eq('string') }
  its(:open_api_schema_type) { is_expected.to eq('string') }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:input_name) { is_expected.to eq('product[state]') }
  its(:icon) { is_expected.to eq(:list_ol) }
  its(:default) { is_expected.to eq('available') }
  its(:search_column) { is_expected.to eq(:state) }
  its(:search_predicate) { is_expected.to eq(:in) }
  its(:search_query) { is_expected.to eq(:state_in) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('products.state') }
  its(:to_s) { is_expected.to eq('state:integer:index') }
  its(:to_spec) { is_expected.to eq('A product has a **state** attribute of type *enumeration*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.product.state') }
  its(:openai_description) { is_expected.to eq('An attribute which represents an enumeration') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::Values
    )
  end

  its(:validators) do
    is_expected.to eq(
      {
        inclusion: {
          in: %w[available available_soon not_available],
          allow_blank: true
        }
      }
    )
  end

  its(:collection) do
    is_expected.to eq(
      [
        %w[Available available],
        ['Available soon', 'available_soon'],
        ['Not available', 'not_available']
      ]
    )
  end

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :state, {:inclusion=>{:in=>["available", "available_soon", "not_available"], :allow_blank=>true}}
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      enum :state,
           {:available=>0, :available_soon=>1, :not_available=>2},
           prefix: true,
           validate: { allow_blank: true }
    RUBY
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      enum: {
        type: 'object',
        additionalProperties: false,
        required: %w[name type options],
        properties: {
          type: {
            type: 'string',
            description: 'An attribute which represents an enumeration',
            enum: %w[enum]
          },
          name: { '$ref': '#/$defs/name' },
          options: {
            type: 'object',
            additionalProperties: false,
            anyOf: [
              { '$ref': '#/$defs/required' },
              { '$ref': '#/$defs/default' },
              { '$ref': '#/$defs/readonly' },
              { '$ref': '#/$defs/values' }
            ]
          }
        }
      }
    )
  end

  context 'when required' do
    let(:options) do
      {
        required: true,
        values: %w[available available_soon not_available]
      }
    end

    its(:collection) do
      is_expected.to eq(
        [
          %w[Available available],
          ['Available soon', 'available_soon'],
          ['Not available', 'not_available']
        ]
      )
    end

    its(:validators) do
      is_expected.to eq(
        inclusion: { in: %w[available available_soon not_available], allow_blank: false },
        presence: true
      )
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :state, {:presence=>true, :inclusion=>{:in=>["available", "available_soon", "not_available"], :allow_blank=>false}}
      RUBY
    end
  end

  context 'when there is a default' do
    let(:options) do
      {
        default: 'available',
        values: %w[available available_soon not_available]
      }
    end

    its(:to_str) do
      is_expected.to eq <<~RUBY
        enum :state,
             {:available=>0, :available_soon=>1, :not_available=>2},
             prefix: true,
             validate: { allow_blank: true },
             default: "available"
      RUBY
    end
  end

  context 'when there is no value' do
    let(:options) { {} }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        enum :state, prefix: true, validate: { allow_blank: true }
      RUBY
    end
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 'available' }

    it { is_expected.to eq('Available') }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::Flag,
        Schematics::Attributes::StateMachine
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
