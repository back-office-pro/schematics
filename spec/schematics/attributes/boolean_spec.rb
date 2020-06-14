describe Schematics::Attributes::Boolean do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) do
    Schematics::Entities::Entity.create(
      name: "entity",
      descriptor: "type",
      attributes: [{ name: "type", type: "string" }]
    )
  end
  let(:name) { "toggle" }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:icon) { is_expected.to eq(:toggle_on) }
end
