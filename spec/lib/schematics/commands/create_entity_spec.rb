# frozen_string_literal: true

describe Schematics::Commands::CreateEntity do
  subject(:command) { described_class.new(entity:) }

  include_context 'with custom generated attribute'

  let(:schema) { Schematics::Schema.new }
  let(:entity) do
    Schematics::Entities::Entity.new(schema:, name:, attributes:, associations:)
  end
  let(:name) { 'assembly' }
  let(:behavior) { :invoke }
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

    its(:size) { is_expected.to eq(9) }
    its([0]) { is_expected.to be_a(TranslationsGenerator) }
    its([0]) { is_expected.to have_attributes(name:, behavior:) }
    its([1]) { is_expected.to be_a(PermissionGenerator) }
    its([2]) { is_expected.to be_a(PermissionGenerator) }
    its([3]) { is_expected.to be_a(PermissionGenerator) }
    its([4]) { is_expected.to be_a(PermissionGenerator) }
    its([5]) { is_expected.to be_a(PermissionGenerator) }
    its([6]) { is_expected.to be_a(PermissionGenerator) }
    its([7]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
    its([7]) { is_expected.to have_attributes(name: 'create_assemblies', behavior:) }
    its([8]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }

    its([1]) do
      is_expected.to have_attributes(
        name: 'Assembly',
        options: a_hash_including(action: 'index'),
        behavior:
      )
    end

    its([2]) do
      is_expected.to have_attributes(
        name: 'Assembly',
        options: a_hash_including(action: 'show'),
        behavior:
      )
    end

    its([3]) do
      is_expected.to have_attributes(
        name: 'Assembly',
        options: a_hash_including(action: 'create'),
        behavior:
      )
    end

    its([4]) do
      is_expected.to have_attributes(
        name: 'Assembly',
        options: a_hash_including(action: 'update'),
        behavior:
      )
    end

    its([5]) do
      is_expected.to have_attributes(
        name: 'Assembly',
        options: a_hash_including(action: 'destroy'),
        behavior:
      )
    end

    its([6]) do
      is_expected.to have_attributes(
        name: 'Assembly',
        options: a_hash_including(action: 'archive'),
        behavior:
      )
    end

    its([8]) do
      is_expected.to have_attributes(
        name: 'create_join_table_assemblies_users',
        behavior:
      )
    end
  end
end
