# frozen_string_literal: true

describe Schematics::Attributes::Duration do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'movie') }
  let(:name) { 'duration' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }
  it { is_expected.to be_a(Schematics::Behaviours::Numerable) }

  its(:database_type) { is_expected.to eq('integer') }
  its(:column_name) { is_expected.to eq('duration') }
  its(:open_api_type) { is_expected.to eq(Integer) }
  its(:icon) { is_expected.to eq(:hourglass) }

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 100 }

    it { is_expected.to eq('1 minute and 40 seconds') }
  end
end
