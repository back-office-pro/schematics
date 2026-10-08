# frozen_string_literal: true

describe Schematics::Commands::RenameEntity do
  subject(:command) { described_class.new(entity:, attribute:) }

  include_context 'with custom generated attribute'

  let(:schema) { Schematics::Schema.new(data:) }
  let(:data) do
    [
      name: 'prospect',
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
  let(:name) { 'prospect' }
  let(:old_name) { 'client' }
  let(:entity) { schema.find_entity_by_name(name) }
  let(:attribute) { Schematics::Entities::Entity.new(schema:, name: old_name) }
  let(:behavior) { :invoke }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Rename the entity **client** to **prospect**') }
  its(:weight) { is_expected.to eq(1) }

  describe '#generators' do
    subject { command.generators }

    its(:size) { is_expected.to eq(12) }
    its([0]) { is_expected.to be_a(TranslationsGenerator) }
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

    its([0]) do
      is_expected.to have_attributes(
        name: 'prospect',
        options: a_hash_including(rename: 'client'),
        behavior:
      )
    end

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

  context 'with a parent entity' do
    let(:data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'stock_portfolio',
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
            parent: 'stock_portfolio'
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
            parent: 'stock_portfolio'
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
    let(:name) { 'stock_portfolio' }
    let(:old_name) { 'portfolio' }

    describe '#generators' do
      subject { command.generators }

      its(:size) { is_expected.to eq(6) }
      its([0]) { is_expected.to be_a(TranslationsGenerator) }
      its([1]) { is_expected.to be_a(TranslationGenerator) }
      its([2]) { is_expected.to be_a(TranslationGenerator) }
      its([3]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its([4]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its([5]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name:,
          options: a_hash_including(rename: 'portfolio'),
          behavior:
        )
      end

      its([1]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.stock_portfolio.name',
          options: a_hash_including(rename: 'activerecord.attributes.portfolio.name'),
          behavior:
        )
      end

      its([2]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.stock_portfolio.users',
          options: a_hash_including(rename: 'activerecord.attributes.portfolio.users'),
          behavior:
        )
      end

      its([3]) do
        is_expected.to have_attributes(
          name: 'rename_portfolios_to_stock_portfolios',
          behavior:
        )
      end

      its([4]) do
        is_expected.to have_attributes(
          name: 'rename_portfolios_users_to_stock_portfolios_users',
          behavior:
        )
      end

      its([5]) do
        is_expected.to have_attributes(
          name: 'rename_portfolio_id_to_stock_portfolio_id_in_stock_portfolios_users',
          behavior:
        )
      end
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
          name: 'investment_account',
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
    let(:name) { 'investment_account' }
    let(:old_name) { 'brokerage_account' }

    describe '#generators' do
      subject { command.generators }

      its(:size) { is_expected.to eq(6) }
      its([0]) { is_expected.to be_a(TranslationsGenerator) }
      its([1]) { is_expected.to be_a(TranslationGenerator) }
      its([2]) { is_expected.to be_a(TranslationGenerator) }
      its([3]) { is_expected.to be_a(PermissionsGenerator) }
      its([4]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its([5]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name:,
          options: a_hash_including(rename: 'brokerage_account'),
          behavior:
        )
      end

      its([1]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.investment_account.fees',
          options: a_hash_including(rename: 'activerecord.attributes.brokerage_account.fees'),
          behavior:
        )
      end

      its([2]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.investment_account.teams',
          options: a_hash_including(rename: 'activerecord.attributes.brokerage_account.teams'),
          behavior:
        )
      end

      its([3]) do
        is_expected.to have_attributes(
          name: 'InvestmentAccount',
          options: a_hash_including(rename: 'BrokerageAccount'),
          behavior:
        )
      end

      its([4]) do
        is_expected.to have_attributes(
          name: 'rename_brokerage_accounts_teams_to_portfolios_teams',
          behavior:
        )
      end

      its([5]) do
        is_expected.to have_attributes(
          name: 'rename_brokerage_account_id_to_portfolio_id_in_portfolios_teams',
          behavior:
        )
      end
    end
  end
end
