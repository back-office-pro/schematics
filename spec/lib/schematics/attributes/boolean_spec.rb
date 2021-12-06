# frozen_string_literal: true

describe Schematics::Attributes::Boolean do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'entity') }
  let(:name) { 'toggle' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:type) { is_expected.to eq('boolean') }
  its(:column_name) { is_expected.to eq('toggle') }
  its(:icon) { is_expected.to eq(:toggle_on) }
  its(:options_for_migration) { is_expected.to be_empty }

  context 'when there is a default value' do
    let(:options) { { default: true } }

    its(:options_for_migration) { is_expected.to eq(default: true) }
  end
end
