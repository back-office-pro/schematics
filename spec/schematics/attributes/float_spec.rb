require 'schematics/attributes/float'

describe Schematics::Attributes::Float do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) do
    Schematics::Entities::Entity.create(
      name: 'entity',
      descriptor: 'type',
      attributes: [{ name: 'type', type: 'string' }]
    )
  end
  let(:name) { 'price' }
  let(:options) do
    {
      unit: '€',
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }

  its(:type) { is_expected.to eq('float') }
  its(:column_name) { is_expected.to eq('price') }
  its(:unit) { is_expected.to eq('€') }
  its(:validators) { is_expected.to eq({ numericality: { allow_nil: true } }) }
  its(:icon) { is_expected.to eq(:sort_numeric_up) }
end
