describe Schematics::Schema do
  subject(:schema) { described_class.instance }

  describe "#find_entity_by_name" do
    subject { schema.find_entity_by_name('user') }

    it { is_expected.to be_a(Schematics::Entities::Entity) }
  end

  describe "#valid?" do
    subject { schema.valid? }

    it { is_expected.to be_truthy }
  end
end
