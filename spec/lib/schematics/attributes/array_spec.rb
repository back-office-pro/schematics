# frozen_string_literal: true

describe Schematics::Attributes::Array do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'comparison') }
  let(:name) { 'ids' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:icon) { is_expected.to eq(:table) }
  its(:database_index_type) { is_expected.to eq(:gin) }
  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('ids') }
  its(:open_api_type) { is_expected.to eq([String]) }
  its(:validators) { is_expected.to be_empty }
  its('validators.to_str') { is_expected.to be_blank }
  its(:weight) { is_expected.to eq(1) }
  its(:default) { is_expected.to be_empty }
  its(:permitted_params) { is_expected.to eq(ids: []) }
  its(:to_sql) { is_expected.to eq('comparisons.ids') }
  its(:to_s) { is_expected.to eq('schema:comparison_ids') }
  its(:options_for_migration) { is_expected.to eq(array: true) }
end
