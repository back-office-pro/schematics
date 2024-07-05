# frozen_string_literal: true

describe Schematics::Commands::RenameEntity do
  subject(:command) { described_class.new(entity:, attribute:, target:) }

  include_context 'with custom generated attribute'

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'prospect') }
  let(:attribute) { Schematics::Entities::Entity.new(schema:, name: 'client') }
  let(:target) { nil }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Rename the entity **client** to **prospect**') }
  its(:weight) { is_expected.to eq(1) }

  describe '#generators' do
    subject { command.generators }

    context 'when building' do
      let(:target) { :build }

      its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its([0]) { is_expected.to have_attributes(name: 'rename_clients_to_prospects') }
      its([1]) { is_expected.to be_a(Rails::Generators::ScaffoldGenerator) }
      its([1]) { is_expected.to have_attributes(name: 'prospect') }
      its([2]) { is_expected.to be_a(Rspec::Generators::FeatureGenerator) }
      its([2]) { is_expected.to have_attributes(name: 'prospect') }
      its([3]) { is_expected.to be_a(TranslationsGenerator) }
      its([3]) { is_expected.to have_attributes(name: 'prospect') }
      its([4]) { is_expected.to be_a(PermissionsGenerator) }
      its([4]) { is_expected.to have_attributes(name: 'prospect') }
      its(:size) { is_expected.to eq(5) }
    end

    context 'when cleaning' do
      let(:target) { :clean }

      its([0]) { is_expected.to be_a(Rails::Generators::ScaffoldGenerator) }
      its([0]) { is_expected.to have_attributes(name: 'prospect') }
      its([1]) { is_expected.to be_a(Rspec::Generators::FeatureGenerator) }
      its([1]) { is_expected.to have_attributes(name: 'prospect') }
      its(:size) { is_expected.to eq(2) }
    end
  end
end
