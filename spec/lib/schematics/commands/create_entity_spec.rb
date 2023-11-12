# frozen_string_literal: true

describe Schematics::Commands::CreateEntity do
  subject(:command) { described_class.new(entity:) }

  include_context 'with custom generated attribute'

  let(:schema) { Schematics::Schema.new }
  let(:entity) do
    Schematics::Entities::Entity.new(schema:, name:, attributes:, associations:, options:)
  end
  let(:name) { 'assembly' }
  let(:options) { {} }
  let(:attributes) do
    [
      {
        name: 'name',
        type: 'string'
      },
      {
        name: 'owner',
        type: 'user'
      }
    ]
  end
  let(:associations) do
    [
      {
        type: 'has_and_belongs_to_many',
        name: 'users'
      }
    ]
  end

  its(:to_spec) { is_expected.to eq('Add an entity Assembly') }
  its(:weight) { is_expected.to eq(1) }

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(Rails::Generators::ScaffoldGenerator) }
    its([1]) { is_expected.to be_a(Rspec::Generators::FeatureGenerator) }
    its([2]) { is_expected.to be_a(TranslationsGenerator) }
    its([3]) { is_expected.to be_a(PermissionsGenerator) }
    its([4]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
    its([5]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
    its(:size) { is_expected.to eq(6) }

    context 'when entity class already exists' do
      let(:options) { { existing: true } }

      its([0]) { is_expected.to be_a(Rails::Generators::ScaffoldControllerGenerator) }
      its(:size) { is_expected.to eq(1) }
    end
  end
end
