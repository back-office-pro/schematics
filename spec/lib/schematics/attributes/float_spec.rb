# frozen_string_literal: true

describe Schematics::Attributes::Float do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'entity') }
  let(:name) { 'weight' }
  let(:options) do
    {
      unit: 'kg'
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }
  it { is_expected.to be_a(Schematics::Behaviours::Numerable) }

  its(:type) { is_expected.to eq('float') }
  its(:column_name) { is_expected.to eq('weight') }
  its(:open_api_type) { is_expected.to eq(Float) }
  its(:unit) { is_expected.to eq('kg') }
  its(:validators) { is_expected.to eq(numericality: { allow_blank: true }) }
  its(:icon) { is_expected.to eq(:sort_numeric_up) }

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 100.099 }

    it { is_expected.to eq('100.099 kg') }
  end
end
