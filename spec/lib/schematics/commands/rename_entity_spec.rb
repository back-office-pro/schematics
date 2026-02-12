# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Commands::RenameEntity do
  subject(:command) { described_class.new(entity:, attribute:) }

  include_context 'with custom generated attribute'

  let(:schema) { Schematics::Schema.new }
  let(:entity) do
    Schematics::Entities::Entity.new(schema:, name: 'prospect', attributes:, associations:)
  end
  let(:attribute) do
    Schematics::Entities::Entity.new(schema:, name: 'client', attributes:, associations:)
  end
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
  end
  let(:associations) do
    [
      type: 'has_and_belongs_to_many',
      name: 'users'
    ]
  end

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Rename the entity **client** to **prospect**') }
  its(:weight) { is_expected.to eq(1) }

  describe '#generators' do
    subject { command.generators }

    its(:size) { is_expected.to eq(12) }
    its([0]) { is_expected.to be_a(TranslationsGenerator) }
    its([0]) { is_expected.to have_attributes(name: 'prospect', behavior:) }
    its([1]) { is_expected.to be_a(TranslationGenerator) }
    its([2]) { is_expected.to be_a(TranslationGenerator) }
    its([3]) { is_expected.to be_a(TranslationGenerator) }
    its([4]) { is_expected.to be_a(TranslationGenerator) }
    its([5]) { is_expected.to be_a(TranslationGenerator) }
    its([6]) { is_expected.to be_a(TranslationGenerator) }
    its([7]) { is_expected.to be_a(TranslationGenerator) }
    its([8]) { is_expected.to be_a(PermissionsGenerator) }
    its([9]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
    its([9]) { is_expected.to have_attributes(name: 'rename_clients_to_prospects', behavior:) }
    its([10]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
    its([11]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }

    its([1]) do
      is_expected.to have_attributes(
        name: 'activerecord.attributes.prospect.name',
        options: a_hash_including(rename: 'activerecord.attributes.client.name'),
        behavior:
      )
    end

    its([2]) do
      is_expected.to have_attributes(
        name: 'activerecord.attributes.prospect.owner',
        options: a_hash_including(rename: 'activerecord.attributes.client.owner'),
        behavior:
      )
    end

    its([3]) do
      is_expected.to have_attributes(
        name: 'activerecord.attributes.prospect.state',
        options: a_hash_including(rename: 'activerecord.attributes.client.state'),
        behavior:
      )
    end

    its([4]) do
      is_expected.to have_attributes(
        name: 'activerecord.attributes.prospect.users',
        options: a_hash_including(rename: 'activerecord.attributes.client.users'),
        behavior:
      )
    end

    its([5]) do
      is_expected.to have_attributes(
        name: 'activerecord.enums.prospect.state.pending',
        options: a_hash_including(rename: 'activerecord.enums.client.state.pending'),
        behavior:
      )
    end

    its([6]) do
      is_expected.to have_attributes(
        name: 'activerecord.enums.prospect.state.closed',
        options: a_hash_including(rename: 'activerecord.enums.client.state.closed'),
        behavior:
      )
    end

    its([7]) do
      is_expected.to have_attributes(
        name: 'activerecord.events.prospect.close',
        options: a_hash_including(rename: 'activerecord.events.client.close'),
        behavior:
      )
    end

    its([8]) do
      is_expected.to have_attributes(
        name: 'Prospect',
        options: a_hash_including(rename: 'Client'),
        behavior:
      )
    end

    its([10]) do
      is_expected.to have_attributes(
        name: 'rename_clients_users_to_prospects_users',
        behavior:
      )
    end

    its([11]) do
      is_expected.to have_attributes(
        name: 'rename_client_id_to_prospect_id_in_prospects_users',
        behavior:
      )
    end
  end
end
