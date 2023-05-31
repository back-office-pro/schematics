# frozen_string_literal: true

describe Schematics::Attributes::Array do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'comparison') }
  let(:name) { 'ids' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }

  its(:icon) { is_expected.to eq(:list) }
  its(:database_index_type) { is_expected.to eq(:gin) }
  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('ids') }
  its(:open_api_type) { is_expected.to eq([String]) }
  its(:validators) { is_expected.to be_empty }
  its('validators.to_str') { is_expected.to be_blank }
  its(:weight) { is_expected.to eq(1) }
  its(:default) { is_expected.to be_all(String) }
  its(:permitted_params) { is_expected.to eq(ids: []) }
  its(:to_sql) { is_expected.to eq('comparisons.ids') }
  its(:to_s) { is_expected.to eq('schema:comparison_ids') }
  its(:migration_options) { is_expected.to eq(array: true) }
  its(:available_options) { is_expected.to include(Schematics::Options::Default) }
  its(:search_column) { is_expected.to eq(:ids) }
  its(:search_predicate) { is_expected.to eq(:any) }
  its(:search_query) { is_expected.to eq(:ids_any) }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      ids: ids&.join(',')
    RUBY
  end

  describe '#format' do
    subject { attribute.format(values) }

    let(:values) { %w[foo bar] }

    it { is_expected.to eq('foo, bar') }
  end
end
