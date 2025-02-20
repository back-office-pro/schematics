# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Attributes::Flag do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'product') }
  let(:name) { 'states' }
  let(:options) { { values: %w[available available_soon not_available] } }

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
  it { is_expected.to be_a(Schematics::Behaviours::Enumerable) }

  its(:database_type) { is_expected.to eq('integer') }
  its(:column_name) { is_expected.to eq('states') }
  its(:open_api_body_type) { is_expected.to eq(['string']) }
  its(:open_api_schema_type) { is_expected.to eq(['string']) }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:input_name) { is_expected.to eq('product[states][]') }
  its(:icon) { is_expected.to eq(:list_ol) }
  its(:default) { is_expected.to eq(['available']) }
  its(:search_column) { is_expected.to eq(:states) }
  its(:search_predicate) { is_expected.to eq(:in) }
  its(:search_query) { is_expected.to eq(:states_in) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('products.states') }
  its(:to_s) { is_expected.to eq('states:integer:index') }
  its(:permitted_params) { is_expected.to eq(states: []) }
  its(:to_spec) { is_expected.to eq('A product has a **states** attribute of type *flag*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.product.states') }

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
        inclusion: { in: %i[available available_soon not_available], allow_blank: true }
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
      validates :states, {inclusion: {in: [:available, :available_soon, :not_available], allow_blank: true}}
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      enummer states: {available: 0, available_soon: 1, not_available: 2}, _prefix: true
    RUBY
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
        inclusion: { in: %i[available available_soon not_available], allow_blank: false },
        presence: true
      )
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :states, {presence: true, inclusion: {in: [:available, :available_soon, :not_available], allow_blank: false}}
      RUBY
    end
  end

  context 'when there is no value' do
    let(:options) { {} }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        enummer states: {}, _prefix: true
      RUBY
    end
  end

  describe '#format' do
    subject { attribute.format(values) }

    let(:values) { %w[available available_soon] }

    it { is_expected.to eq('Available, Available soon') }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::Enum,
        Schematics::Attributes::StateMachine
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
