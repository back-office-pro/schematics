# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Commands::CreateEntity do
  subject(:command) { described_class.new(entity:) }

  include_context 'with custom generated attribute'

  let(:schema) { Schematics::Schema.new(data:) }
  let(:entity) { schema.find_entity_by_name(name) }
  let(:name) { 'assembly' }
  let(:behavior) { :invoke }
  let(:data) do
    [
      name: 'assembly',
      associations: [
        type: 'has_and_belongs_to_many',
        name: 'users'
      ],
      attributes: [
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
              name: 'close',
              from: 'pending',
              to: 'closed'
            ]
          }
        }
      ]
    ]
  end

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Add an entity **assembly**') }
  its(:weight) { is_expected.to eq(1) }

  describe '#generators' do
    subject { command.generators }

    its(:size) { is_expected.to eq(17) }
    its([0]) { is_expected.to be_a(TranslationsGenerator) }
    its([0]) { is_expected.to have_attributes(name:, behavior:) }
    its([1]) { is_expected.to be_a(TranslationGenerator) }
    its([2]) { is_expected.to be_a(TranslationGenerator) }
    its([3]) { is_expected.to be_a(TranslationGenerator) }
    its([4]) { is_expected.to be_a(TranslationGenerator) }
    its([5]) { is_expected.to be_a(TranslationGenerator) }
    its([6]) { is_expected.to be_a(TranslationGenerator) }
    its([7]) { is_expected.to be_a(TranslationGenerator) }
    its([8]) { is_expected.to be_a(PermissionGenerator) }
    its([9]) { is_expected.to be_a(PermissionGenerator) }
    its([10]) { is_expected.to be_a(PermissionGenerator) }
    its([11]) { is_expected.to be_a(PermissionGenerator) }
    its([12]) { is_expected.to be_a(PermissionGenerator) }
    its([13]) { is_expected.to be_a(PermissionGenerator) }
    its([14]) { is_expected.to be_a(PermissionGenerator) }
    its([15]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
    its([15]) { is_expected.to have_attributes(name: 'create_assemblies', behavior:) }
    its([16]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }

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

    its([8]) do
      is_expected.to have_attributes(
        name: 'Assembly',
        options: a_hash_including(action: 'index'),
        behavior:
      )
    end

    its([9]) do
      is_expected.to have_attributes(
        name: 'Assembly',
        options: a_hash_including(action: 'show'),
        behavior:
      )
    end

    its([10]) do
      is_expected.to have_attributes(
        name: 'Assembly',
        options: a_hash_including(action: 'create'),
        behavior:
      )
    end

    its([11]) do
      is_expected.to have_attributes(
        name: 'Assembly',
        options: a_hash_including(action: 'update'),
        behavior:
      )
    end

    its([12]) do
      is_expected.to have_attributes(
        name: 'Assembly',
        options: a_hash_including(action: 'destroy'),
        behavior:
      )
    end

    its([13]) do
      is_expected.to have_attributes(
        name: 'Assembly',
        options: a_hash_including(action: 'archive'),
        behavior:
      )
    end

    its([14]) do
      is_expected.to have_attributes(
        name: 'Assembly',
        options: a_hash_including(action: 'close'),
        behavior:
      )
    end

    its([16]) do
      is_expected.to have_attributes(
        name: 'create_join_table_assemblies_users',
        behavior:
      )
    end
  end

  context 'with a parent entity' do
    let(:data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'portfolio',
          associations: [
            type: 'has_and_belongs_to_many',
            name: 'users'
          ],
          attributes: [
            id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
            name: 'name',
            type: 'string'
          ]
        },
        {
          id: '5311570e-b976-410d-b5d9-48eb928c8fb1',
          name: 'brokerage_account',
          options: {
            parent: 'portfolio'
          },
          associations: [
            type: 'has_and_belongs_to_many',
            name: 'teams'
          ],
          attributes: [
            id: 'd46f9336-d17e-4840-bd90-c36c8b44ca6d',
            name: 'fees',
            type: 'percentage'
          ]
        },
        {
          id: '635476ac-2c51-4ce2-a23b-2c8ba6535598',
          name: 'life_insurance',
          options: {
            parent: 'portfolio'
          },
          associations: [
            type: 'has_and_belongs_to_many',
            name: 'roles'
          ],
          attributes: [
            id: '286ce97a-d000-4c26-93ea-7a969850d124',
            name: 'age',
            type: 'integer'
          ]
        }
      ]
    end
    let(:name) { 'portfolio' }

    describe '#generators' do
      subject { command.generators }

      it { is_expected.to be_empty }
    end
  end

  context 'with a child entity' do
    let(:data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'portfolio',
          associations: [
            type: 'has_and_belongs_to_many',
            name: 'users'
          ],
          attributes: [
            id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
            name: 'name',
            type: 'string'
          ]
        },
        {
          id: '5311570e-b976-410d-b5d9-48eb928c8fb1',
          name: 'brokerage_account',
          options: {
            parent: 'portfolio'
          },
          associations: [
            type: 'has_and_belongs_to_many',
            name: 'teams'
          ],
          attributes: [
            id: 'd46f9336-d17e-4840-bd90-c36c8b44ca6d',
            name: 'fees',
            type: 'percentage'
          ]
        },
        {
          id: '635476ac-2c51-4ce2-a23b-2c8ba6535598',
          name: 'life_insurance',
          options: {
            parent: 'portfolio'
          },
          associations: [
            type: 'has_and_belongs_to_many',
            name: 'roles'
          ],
          attributes: [
            id: '286ce97a-d000-4c26-93ea-7a969850d124',
            name: 'age',
            type: 'integer'
          ]
        }
      ]
    end
    let(:name) { 'brokerage_account' }

    describe '#generators' do
      subject { command.generators }

      its(:size) { is_expected.to eq(14) }
      its([0]) { is_expected.to be_a(TranslationsGenerator) }
      its([0]) { is_expected.to have_attributes(name:, behavior:) }
      its([1]) { is_expected.to be_a(TranslationGenerator) }
      its([2]) { is_expected.to be_a(TranslationGenerator) }
      its([3]) { is_expected.to be_a(TranslationGenerator) }
      its([4]) { is_expected.to be_a(TranslationGenerator) }
      its([5]) { is_expected.to be_a(PermissionGenerator) }
      its([6]) { is_expected.to be_a(PermissionGenerator) }
      its([7]) { is_expected.to be_a(PermissionGenerator) }
      its([8]) { is_expected.to be_a(PermissionGenerator) }
      its([9]) { is_expected.to be_a(PermissionGenerator) }
      its([10]) { is_expected.to be_a(PermissionGenerator) }
      its([11]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its([11]) { is_expected.to have_attributes(name: 'create_brokerage_accounts', behavior:) }
      its([12]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its([13]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }

      its([1]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.brokerage_account.fees',
          behavior:
        )
      end

      its([2]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.brokerage_account.name',
          behavior:
        )
      end

      its([3]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.brokerage_account.teams',
          behavior:
        )
      end

      its([4]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.brokerage_account.users',
          behavior:
        )
      end

      its([5]) do
        is_expected.to have_attributes(
          name: 'BrokerageAccount',
          options: a_hash_including(action: 'index'),
          behavior:
        )
      end

      its([6]) do
        is_expected.to have_attributes(
          name: 'BrokerageAccount',
          options: a_hash_including(action: 'show'),
          behavior:
        )
      end

      its([7]) do
        is_expected.to have_attributes(
          name: 'BrokerageAccount',
          options: a_hash_including(action: 'create'),
          behavior:
        )
      end

      its([8]) do
        is_expected.to have_attributes(
          name: 'BrokerageAccount',
          options: a_hash_including(action: 'update'),
          behavior:
        )
      end

      its([9]) do
        is_expected.to have_attributes(
          name: 'BrokerageAccount',
          options: a_hash_including(action: 'destroy'),
          behavior:
        )
      end

      its([10]) do
        is_expected.to have_attributes(
          name: 'BrokerageAccount',
          options: a_hash_including(action: 'archive'),
          behavior:
        )
      end

      its([12]) do
        is_expected.to have_attributes(
          name: 'create_join_table_brokerage_accounts_teams',
          behavior:
        )
      end

      its([13]) do
        is_expected.to have_attributes(
          name: 'create_join_table_brokerage_accounts_users',
          behavior:
        )
      end
    end
  end
end
