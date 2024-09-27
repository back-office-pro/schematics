# frozen_string_literal: true

describe Schematics::Commands::RenameEntity do
  subject(:command) { described_class.new(entity:, attribute:, target:) }

  include_context 'with custom generated attribute'

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'prospect', associations:) }
  let(:attribute) { Schematics::Entities::Entity.new(schema:, name: 'client', associations:) }
  let(:target) { nil }
  let(:associations) do
    [
      {
        type: 'has_and_belongs_to_many',
        name: 'users'
      }
    ]
  end

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Rename the entity **client** to **prospect**') }
  its(:weight) { is_expected.to eq(1) }

  describe '#generators' do
    subject { command.generators }

    context 'when building' do
      let(:target) { :build }
      let(:behavior) { :invoke }

      its(:size) { is_expected.to eq(7) }
      its([0]) { is_expected.to be_a(Rails::Generators::ScaffoldGenerator) }
      its([0]) { is_expected.to have_attributes(name: 'prospect', behavior:) }
      its([1]) { is_expected.to be_a(Rspec::Generators::FeatureGenerator) }
      its([1]) { is_expected.to have_attributes(name: 'prospect', behavior:) }
      its([2]) { is_expected.to be_a(TranslationsGenerator) }
      its([2]) { is_expected.to have_attributes(name: 'prospect', behavior:) }
      its([3]) { is_expected.to be_a(PermissionsGenerator) }
      its([3]) { is_expected.to have_attributes(name: 'prospect', behavior:) }
      its([4]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its([4]) { is_expected.to have_attributes(name: 'rename_clients_to_prospects', behavior:) }
      its([5]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its([6]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }

      its([5]) do
        is_expected.to have_attributes(
          name: 'rename_clients_users_to_prospects_users',
          behavior:
        )
      end

      its([6]) do
        is_expected.to have_attributes(
          name: 'rename_client_id_to_prospect_id_in_prospects_users',
          behavior:
        )
      end
    end

    context 'when cleaning' do
      let(:target) { :clean }
      let(:behavior) { :revoke }

      its([0]) { is_expected.to be_a(Rails::Generators::ScaffoldGenerator) }
      its([0]) { is_expected.to have_attributes(name: 'prospect', behavior:) }
      its([1]) { is_expected.to be_a(Rspec::Generators::FeatureGenerator) }
      its([1]) { is_expected.to have_attributes(name: 'prospect', behavior:) }
      its(:size) { is_expected.to eq(2) }
    end
  end
end
