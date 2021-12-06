# frozen_string_literal: true

describe Schematics::Attributes::Uuid do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'entity') }
  let(:name) { 'id' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }

  its(:type) { is_expected.to eq('uuid') }
  its(:column_name) { is_expected.to eq('id') }
  its(:validators) { is_expected.to be_empty }
end
