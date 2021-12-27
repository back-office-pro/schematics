# frozen_string_literal: true

describe Schematics::Attributes::Percentage do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'import') }
  let(:name) { 'progress' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }
  it { is_expected.to be_a(Schematics::Behaviours::Numerable) }

  its(:type) { is_expected.to eq('float') }
  its(:column_name) { is_expected.to eq('progress') }
  its(:open_api_type) { is_expected.to eq(:number) }
  its(:validators) { is_expected.to eq(numericality: { allow_nil: true }) }
  its(:icon) { is_expected.to eq(:percentage) }

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 100 }

    it { is_expected.to eq('100.000%') }
  end
end
