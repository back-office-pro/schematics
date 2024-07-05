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

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Add an entity **assembly**') }
  its(:weight) { is_expected.to eq(1) }

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(Rails::Generators::ScaffoldGenerator) }
    its([0]) { is_expected.to have_attributes(name:) }
    its([1]) { is_expected.to be_a(Rspec::Generators::FeatureGenerator) }
    its([1]) { is_expected.to have_attributes(name:) }
    its([2]) { is_expected.to be_a(TranslationsGenerator) }
    its([2]) { is_expected.to have_attributes(name:) }
    its([3]) { is_expected.to be_a(PermissionsGenerator) }
    its([3]) { is_expected.to have_attributes(name:) }
    its([4]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
    its([4]) { is_expected.to have_attributes(name: 'create_assemblies') }
    its([5]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
    its([5]) { is_expected.to have_attributes(name: 'create_join_table_assemblies_users') }
    its(:size) { is_expected.to eq(6) }

    context 'when entity class already exists' do
      let(:options) { { existing: true } }

      its([0]) { is_expected.to be_a(Rails::Generators::ScaffoldControllerGenerator) }
      its([0]) { is_expected.to have_attributes(name:) }
      its(:size) { is_expected.to eq(1) }
    end
  end
end
