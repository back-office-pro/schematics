# frozen_string_literal: true

describe Schematics::Commands::DestroyEntity do
  subject(:command) { described_class.new(entity:) }

  let(:entity) { Schematics::Entities::Entity.new(name:, attributes:, associations:) }
  let(:name) { 'assembly' }
  let(:attributes) do
    [
      {
        name: 'name',
        type: 'string'
      },
      {
        name: 'owner',
        type: 'belongs_to',
        options: {
          type: 'user',
          inverse: {
            name: 'assemblies'
          }
        }
      }
    ]
  end
  let(:associations) do
    [
      {
        type: 'has_and_belongs_to_many',
        name: 'part'
      }
    ]
  end

  its(:weight) { is_expected.to eq(1) }

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(Rails::Generators::ScaffoldGenerator) }
    its([1]) { is_expected.to be_a(Rspec::Generators::FeatureGenerator) }
    its([2]) { is_expected.to be_a(TranslationsGenerator) }
    its([3]) { is_expected.to be_a(PermissionsGenerator) }
    its([4]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
    its([5]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
  end
end
