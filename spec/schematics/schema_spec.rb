require 'schematics/schema'

describe Schematics::Schema do
  subject(:schema) { described_class.instance }

  it { is_expected.to be_valid }

  describe '#find_entity_by_name' do
    subject { schema.find_entity_by_name('user') }

    it { is_expected.to be_a(Schematics::Entities::Entity) }
  end
end
