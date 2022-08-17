# frozen_string_literal: true

describe Schematics::Commands::DestroyEntity do
  subject(:command) { described_class.new(entity:) }

  let(:entity) { Schematics::Entities::Entity.new(name:, attributes:) }
  let(:name) { 'client' }
  let(:attributes) do
    [
      {
        name: 'first_name',
        type: 'string'
      }
    ]
  end

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(Rails::Generators::ScaffoldGenerator) }
    its([1]) { is_expected.to be_a(Rspec::Generators::FeatureGenerator) }
    its([2]) { is_expected.to be_a(LocalesGenerator) }
    its([3]) { is_expected.to be_a(PermissionsGenerator) }
    its([4]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
  end
end
