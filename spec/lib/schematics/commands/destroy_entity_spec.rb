# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Commands::DestroyEntity do
  subject(:command) { described_class.new(entity:) }

  include_context 'with custom generated attribute'

  let(:schema) { Schematics::Schema.new(name: 'demo') }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name:, attributes:, associations:) }
  let(:name) { 'assembly' }
  let(:behavior) { :revoke }
  let(:attributes) do
    [
      {
        name: 'name',
        type: 'string'
      },
      {
        name: 'owner',
        type: 'user'
      },
      {
        name: 'state',
        type: 'state_machine',
        options: {
          values: %w[pending closed],
          events: [
            {
              name: 'close',
              from: 'pending',
              to: 'closed'
            }
          ]
        }
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

  its(:to_spec) { is_expected.to eq('Remove the **assembly** entity') }
  its(:weight) { is_expected.to eq(1) }

  describe '#generators' do
    subject { command.generators }

    its(:size) { is_expected.to eq(11) }
    its([0]) { is_expected.to be_a(TranslationsGenerator) }
    its([0]) { is_expected.to have_attributes(name:, behavior:) }
    its([1]) { is_expected.to be_a(TranslationGenerator) }
    its([2]) { is_expected.to be_a(TranslationGenerator) }
    its([3]) { is_expected.to be_a(TranslationGenerator) }
    its([4]) { is_expected.to be_a(TranslationGenerator) }
    its([5]) { is_expected.to be_a(TranslationGenerator) }
    its([6]) { is_expected.to be_a(TranslationGenerator) }
    its([7]) { is_expected.to be_a(TranslationGenerator) }
    its([8]) { is_expected.to be_a(PermissionsGenerator) }
    its([8]) { is_expected.to have_attributes(name: 'Demo::Assembly', behavior:) }
    its([9]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
    its([9]) { is_expected.to have_attributes(name: 'drop_assemblies', behavior: :invoke) }
    its([10]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }

    its([1]) do
      is_expected.to have_attributes(
        name: 'activerecord.attributes.assembly.name',
        behavior:
      )
    end

    its([2]) do
      is_expected.to have_attributes(
        name: 'activerecord.attributes.assembly.owner',
        behavior:
      )
    end

    its([3]) do
      is_expected.to have_attributes(
        name: 'activerecord.attributes.assembly.state',
        behavior:
      )
    end

    its([4]) do
      is_expected.to have_attributes(
        name: 'activerecord.attributes.assembly.users',
        behavior:
      )
    end

    its([5]) do
      is_expected.to have_attributes(
        name: 'activerecord.enums.assembly.state.pending',
        behavior:
      )
    end

    its([6]) do
      is_expected.to have_attributes(
        name: 'activerecord.enums.assembly.state.closed',
        behavior:
      )
    end

    its([7]) do
      is_expected.to have_attributes(
        name: 'activerecord.events.assembly.close',
        behavior:
      )
    end

    its([10]) do
      is_expected.to have_attributes(
        name: 'drop_join_table_assemblies_users',
        behavior: :invoke
      )
    end
  end
end
