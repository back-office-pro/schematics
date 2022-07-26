# frozen_string_literal: true

describe Schematics::Attributes::Uuid do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'entity') }
  let(:name) { 'id' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }

  its(:database_type) { is_expected.to eq('uuid') }
  its(:column_name) { is_expected.to eq('id') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:default) { is_expected.to be_a(String) }
  its(:validators) { is_expected.to be_empty }
end
