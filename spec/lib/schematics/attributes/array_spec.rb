# frozen_string_literal: true

describe Schematics::Attributes::Array do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'comparison') }
  let(:name) { 'ids' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }

  its(:type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('ids') }
  its(:open_api_type) { is_expected.to eq('string') }
  its(:validators) { is_expected.to be_empty }
  its(:validate) { is_expected.to be_nil }
  its(:weight) { is_expected.to eq(1) }
  its(:default) { is_expected.to be_empty }
  its(:to_sql) { is_expected.to eq('comparisons.ids') }
  its(:to_s) { is_expected.to eq('schema:comparison_ids') }
  its(:options_for_migration) { is_expected.to eq(array: true) }
end
