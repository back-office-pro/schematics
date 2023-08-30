# frozen_string_literal: true

describe Schematics::Attributes::Uuid do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'entity') }
  let(:name) { 'id' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }

  its(:database_type) { is_expected.to eq('uuid') }
  its(:column_name) { is_expected.to eq('id') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:default) { is_expected.to be_a(String) }
  its(:icon) { is_expected.to eq(:id_card) }
  its(:validators) { is_expected.to be_empty }

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class) }
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 'f44b9276-0b51-45ba-ad48-99704ff83e34' }

    it { is_expected.to eq(value) }
  end
end
