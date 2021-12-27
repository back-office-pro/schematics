# frozen_string_literal: true

describe Schematics::Attributes::Currency do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'product') }
  let(:name) { 'price' }
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
  its(:column_name) { is_expected.to eq('price') }
  its(:open_api_type) { is_expected.to eq('number') }
  its(:validators) { is_expected.to eq(numericality: { allow_nil: true }) }
  its(:icon) { is_expected.to eq(:money_bill_wave) }

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 100_000 }

    it { is_expected.to eq('$100,000.00') }
  end
end
