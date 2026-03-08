# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Migrations::Migrate do
  include_context 'with google translate stub'
  include_context 'with user'

  let(:migration) do
    Migration.create!(data:, version: 2.0, state: Migration::STATE_STATE_IN_PROGRESS)
  end
  let(:initial_migration) do
    Migration.create!(data: initial_data, version: 1.0, state: Migration::STATE_STATE_FINISHED)
  end
  let(:root) { Rails.root }
  let(:rollback_user_transaction) { [User, Role, Team].each(&:delete_all) }
  let(:initial_data) do
    [
      id: '3cceed80-55c1-445f-a47b-44705c702c3d',
      name: 'prospect',
      associations: [
        type: 'has_and_belongs_to_many',
        name: 'users'
      ],
      attributes: [
        id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
        name: 'first_name',
        type: 'string'
      ]
    ]
  end
  let(:initial_sti_data) do
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
      }
    ]
  end
  let(:migrate_initial_migration) do
    Dir.chdir(root) { described_class.call(migration: initial_migration) }
  end
  let(:rollback_initial_migration) do
    Dir.chdir(root) do
      Core::Migrations::Rollback.call(migration: initial_migration.tap(&:state_rollbacking!))
    end
  end
  let(:migrate) do
    Dir.chdir(root) { described_class.call(migration:) }
  end
  let(:rollback) do
    Dir.chdir(root) do
      Core::Migrations::Rollback.call(migration: migration.tap(&:state_rollbacking!))
    end
  end

  describe '.call' do
    context 'when creating a new entity' do
      let(:data) { initial_data }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to change(Permission, :count).by(6)
          .and change(Translation, :count).by(15)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_create_prospects_*.rb')]).not_to be_empty
        expect(Dir[root.join('storage/migrate/*_create_join_table_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Prospect }.not_to raise_error
        # rollback
        expect { expect(rollback).to be_a_success }
          .to change(Permission.with_deleted, :count).by(-6)
          .and change(Translation.with_deleted, :count).by(-15)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_drop_prospects_*.rb')]).not_to be_empty
        expect(Dir[root.join('storage/migrate/*_drop_join_table_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Prospect }.to raise_error(NameError)
      end
    end

    context 'when renaming an entity' do
      let(:data) do
        [
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          associations: [
            type: 'has_and_belongs_to_many',
            name: 'users'
          ],
          attributes: [
            id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
            name: 'first_name',
            type: 'string'
          ]
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_rename_prospects_to_clients_*.rb')]).not_to be_empty
        expect(Dir[root.join('storage/migrate/*_rename_prospects_users_to_clients_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_prospect_id_to_client_id_in_clients_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Prospect }.to raise_error(NameError)
        expect { Client }.not_to raise_error
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_rename_clients_to_prospects_*.rb')]).not_to be_empty
        expect(Dir[root.join('storage/migrate/*_rename_clients_users_to_prospects_users*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_client_id_to_prospect_id_in_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Prospect }.not_to raise_error
        expect { Client }.to raise_error(NameError)
      end
    end

    context 'when destroying an entity' do
      let(:resource) { Prospect.create!(first_name: 'John') }
      let(:data) { [] }

      before { [migrate_initial_migration, resource] }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to change(Permission.with_deleted, :count).by(-6)
          .and change(Translation.with_deleted, :count).by(-15)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).to be_attached
        expect(Dir[root.join('storage/migrate/*_drop_prospects_*.rb')]).not_to be_empty
        expect(Dir[root.join('storage/migrate/*_drop_join_table_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Prospect }.to raise_error(NameError)
        expect { resource.reload }.to raise_error(ActiveRecord::StatementInvalid)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to change(Permission, :count).by(6)
          .and change(Translation, :count).by(15)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_create_prospects_*.rb')]).not_to be_empty
        expect(Dir[root.join('storage/migrate/*_create_join_table_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Prospect }.not_to raise_error
        expect { resource.reload }.not_to raise_error
      end
    end

    context 'when adding a new attribute' do
      let(:data) do
        [
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'prospect',
          associations: [
            type: 'has_and_belongs_to_many',
            name: 'users'
          ],
          attributes: [
            {
              id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
              name: 'first_name',
              type: 'string'
            },
            {
              id: 'd46f9336-d17e-4840-bd90-c36c8b44ca6d',
              name: 'last_name',
              type: 'string'
            }
          ]
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation, :count).by(3)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_add_last_name_to_prospects_*.rb')]).not_to be_empty
        expect(Prospect.new).to respond_to(:last_name)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and change(Translation.with_deleted, :count).by(-3)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_remove_last_name_from_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Prospect.new).not_to respond_to(:last_name)
      end
    end

    context 'when removing an attribute' do
      let(:data) do
        [
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'prospect',
          associations: [
            type: 'has_and_belongs_to_many',
            name: 'users'
          ]
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation.with_deleted, :count).by(-3)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_remove_first_name_from_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Prospect.new).not_to respond_to(:first_name)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and change(Translation, :count).by(3)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_add_first_name_to_prospects_*.rb')]).not_to be_empty
        expect(Prospect.new).to respond_to(:first_name)
      end
    end

    context 'when adding a new belongs_to association' do
      let(:data) do
        [
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'prospect',
          associations: [
            type: 'has_and_belongs_to_many',
            name: 'users'
          ],
          attributes: [
            {
              id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
              name: 'first_name',
              type: 'string'
            },
            {
              id: 'fbd1feaa-f83d-4618-8cd0-1e2ad0b95491',
              name: 'user',
              type: 'belongs_to'
            }
          ]
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation, :count).by(3)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_add_user_to_prospects_*.rb')]).not_to be_empty
        expect(Prospect.new).to respond_to(:user)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and change(Translation.with_deleted, :count).by(-3)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_remove_user_from_prospects_*.rb')]).not_to be_empty
        expect(Prospect.new).not_to respond_to(:user)
      end
    end

    context 'when adding a new habtm association' do
      let(:data) do
        [
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'prospect',
          associations: [
            {
              name: 'users',
              type: 'has_and_belongs_to_many'
            },
            {
              name: 'teams',
              type: 'has_and_belongs_to_many'
            }
          ],
          attributes: [
            id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
            name: 'first_name',
            type: 'string'
          ]
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation, :count).by(3)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_create_join_table_prospects_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Prospect.new).to respond_to(:teams)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and change(Translation.with_deleted, :count).by(-3)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_drop_join_table_prospects_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Prospect.new).not_to respond_to(:teams)
      end
    end

    context 'when removing a habtm association' do
      let(:resource) { Prospect.create!(first_name: 'John', users: [user]) }
      let(:data) do
        [
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'prospect',
          attributes: [
            id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
            name: 'first_name',
            type: 'string'
          ]
        ]
      end

      before { [migrate_initial_migration, resource] }

      after { [rollback_initial_migration, rollback_user_transaction] }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation.with_deleted, :count).by(-3)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).to be_attached
        expect(Dir[root.join('storage/migrate/*_drop_join_table_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Prospect.new).not_to respond_to(:users)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation, :count).by(3)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_create_join_table_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Prospect.new).to respond_to(:users)
        expect(resource.reload.users).to eq([user])
      end
    end

    context 'when renaming an attribute' do
      let(:data) do
        [
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'prospect',
          associations: [
            name: 'users',
            type: 'has_and_belongs_to_many'
          ],
          attributes: [
            id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
            name: 'surname',
            type: 'string'
          ]
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_rename_first_name_to_surname_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Prospect.new).not_to respond_to(:first_name)
        expect(Prospect.new).to respond_to(:surname)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_rename_surname_to_first_name_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Prospect.new).to respond_to(:first_name)
        expect(Prospect.new).not_to respond_to(:surname)
      end
    end

    context 'when changing attribute type' do
      let(:data) do
        [
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'prospect',
          associations: [
            name: 'users',
            type: 'has_and_belongs_to_many'
          ],
          attributes: [
            id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
            name: 'first_name',
            type: 'text'
          ]
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_change_first_name_column_string_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_change_first_name_column_text_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
      end
    end

    context 'when changing attribute uniqueness' do
      let(:data) do
        [
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'prospect',
          associations: [
            name: 'users',
            type: 'has_and_belongs_to_many'
          ],
          attributes: [
            id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
            name: 'first_name',
            type: 'string',
            options: {
              unique: true
            }
          ]
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_change_first_name_index_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_change_first_name_index_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
      end
    end

    context 'with a more complex scenario' do
      let(:data) do
        [
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          associations: [
            name: 'users',
            type: 'has_and_belongs_to_many'
          ],
          attributes: [
            id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
            name: 'surname',
            type: 'string'
          ]
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_rename_prospects_to_clients_*.rb')]).not_to be_empty
        expect(Dir[root.join('storage/migrate/*_rename_prospects_users_to_clients_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_prospect_id_to_client_id_in_clients_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_first_name_to_surname_in_clients_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Prospect }.to raise_error(NameError)
        expect { Client }.not_to raise_error
        expect(Client.new).not_to respond_to(:first_name)
        expect(Client.new).to respond_to(:surname)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_rename_clients_to_prospects_*.rb')]).not_to be_empty
        expect(Dir[root.join('storage/migrate/*_rename_clients_users_to_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_client_id_to_prospect_id_in_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_surname_to_first_name_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Prospect }.not_to raise_error
        expect { Client }.to raise_error(NameError)
        expect(Prospect.new).to respond_to(:first_name)
        expect(Prospect.new).not_to respond_to(:surname)
      end
    end

    context 'when migrating core' do
      let(:migration) { Migration.core }
      let(:data) { initial_data }

      uses_transaction 'migrates successfully'

      it 'migrates successfully' do # rubocop:disable RSpec/MultipleExpectations
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
      end
    end

    context 'when creating a new entity with STI' do
      let(:data) { initial_sti_data }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to change(Permission, :count).by(6)
          .and change(Translation, :count).by(33)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_create_portfolios_*.rb')]).not_to be_empty
        expect(Dir[root.join('storage/migrate/*_create_join_table_portfolios_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_create_join_table_portfolios_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Portfolio }.not_to raise_error
        expect { BrokerageAccount }.not_to raise_error
        # rollback
        expect { expect(rollback).to be_a_success }
          .to change(Permission.with_deleted, :count).by(-6)
          .and change(Translation.with_deleted, :count).by(-33)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_drop_portfolios_*.rb')]).not_to be_empty
        expect(Dir[root.join('storage/migrate/*_drop_join_table_portfolios_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_drop_join_table_portfolios_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Portfolio }.to raise_error(NameError)
        expect { BrokerageAccount }.to raise_error(NameError)
      end
    end

    context 'when renaming an entity with STI' do
      let(:initial_data) { initial_sti_data }
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
            name: 'investment_account',
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
          }
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_rename_portfolios_to_stock_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_portfolios_users_to_stock_portfolios_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_portfolio_id_to_stock_portfolio_id_in_stock_portfolios_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_portfolios_teams_to_stock_portfolios_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_portfolio_id_to_stock_portfolio_id_in_stock_portfolios_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Portfolio }.to raise_error(NameError)
        expect { BrokerageAccount }.to raise_error(NameError)
        expect { StockPortfolio }.not_to raise_error
        expect { InvestmentAccount }.not_to raise_error
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_rename_stock_portfolios_to_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_stock_portfolios_users_to_portfolios_users*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_stock_portfolio_id_to_portfolio_id_in_portfolios_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_stock_portfolios_teams_to_portfolios_teams*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_stock_portfolio_id_to_portfolio_id_in_portfolios_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Portfolio }.not_to raise_error
        expect { BrokerageAccount }.not_to raise_error
        expect { StockPortfolio }.to raise_error(NameError)
        expect { InvestmentAccount }.to raise_error(NameError)
      end
    end

    context 'when destroying an entity with STI' do
      let(:initial_data) { initial_sti_data }
      let(:resource) { BrokerageAccount.create!(fees: 2.0) }
      let(:data) { [] }

      before { [migrate_initial_migration, resource] }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to change(Permission.with_deleted, :count).by(-6)
          .and change(Translation.with_deleted, :count).by(-33)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).to be_attached
        expect(Dir[root.join('storage/migrate/*_drop_portfolios_*.rb')]).not_to be_empty
        expect(Dir[root.join('storage/migrate/*_drop_join_table_portfolios_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_drop_join_table_portfolios_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Portfolio }.to raise_error(NameError)
        expect { BrokerageAccount }.to raise_error(NameError)
        expect { resource.reload }.to raise_error(ActiveRecord::StatementInvalid)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to change(Permission, :count).by(6)
          .and change(Translation, :count).by(33)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_create_portfolios_*.rb')]).not_to be_empty
        expect(Dir[root.join('storage/migrate/*_create_join_table_portfolios_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_create_join_table_portfolios_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Portfolio }.not_to raise_error
        expect { BrokerageAccount }.not_to raise_error
        expect { resource.reload }.not_to raise_error
      end
    end

    context 'when adding a new attribute with STI' do
      let(:initial_data) { initial_sti_data }
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
              {
                id: 'd46f9336-d17e-4840-bd90-c36c8b44ca6d',
                name: 'fees',
                type: 'percentage'
              },
              {
                id: '48bd6eda-ec10-43a4-a367-cc39271476de',
                name: 'amount',
                type: 'float'
              }
            ]
          }
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation, :count).by(3)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_add_amount_to_portfolios_*.rb')]).not_to be_empty
        expect(Portfolio.new).to respond_to(:amount)
        expect(BrokerageAccount.new).to respond_to(:amount)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and change(Translation.with_deleted, :count).by(-3)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_remove_amount_from_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Portfolio.new).not_to respond_to(:amount)
        expect(BrokerageAccount.new).not_to respond_to(:amount)
      end
    end

    context 'when removing an attribute with STI' do
      let(:initial_data) { initial_sti_data }
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
            ]
          }
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation.with_deleted, :count).by(-3)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_remove_fees_from_portfolios_*.rb')]).not_to be_empty
        expect(Portfolio.new).not_to respond_to(:fees)
        expect(BrokerageAccount.new).not_to respond_to(:fees)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and change(Translation, :count).by(3)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_add_fees_to_portfolios_*.rb')]).not_to be_empty
        expect(Portfolio.new).to respond_to(:fees)
        expect(BrokerageAccount.new).to respond_to(:fees)
      end
    end

    context 'when adding a new belongs_to association with STI' do
      let(:initial_data) { initial_sti_data }
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
              {
                id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
                name: 'name',
                type: 'string'
              },
              {
                id: 'fc3df26a-8a40-4632-86c7-7e2d072ba8e6',
                name: 'role',
                type: 'belongs_to'
              }
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
              {
                id: 'd46f9336-d17e-4840-bd90-c36c8b44ca6d',
                name: 'fees',
                type: 'percentage'
              },
              {
                id: '182f1360-1eab-40bb-ba8d-4cdbecf6b3d2',
                name: 'permission',
                type: 'belongs_to'
              }
            ]
          }
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation, :count).by(6)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_add_role_to_portfolios_*.rb')]).not_to be_empty
        expect(Dir[root.join('storage/migrate/*_add_permission_to_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Portfolio.new).to respond_to(:role)
        expect(BrokerageAccount.new).to respond_to(:role)
        expect(BrokerageAccount.new).to respond_to(:permission)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and change(Translation.with_deleted, :count).by(-6)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_remove_role_from_portfolios_*.rb')]).not_to be_empty
        expect(Dir[root.join('storage/migrate/*_remove_permission_from_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Portfolio.new).not_to respond_to(:role)
        expect(BrokerageAccount.new).not_to respond_to(:role)
        expect(BrokerageAccount.new).not_to respond_to(:permission)
      end
    end

    context 'when adding a new habtm association with STI' do
      let(:initial_data) { initial_sti_data }
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'portfolio',
            associations: [
              {
                type: 'has_and_belongs_to_many',
                name: 'users'
              },
              {
                type: 'has_and_belongs_to_many',
                name: 'roles'
              }
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
              {
                type: 'has_and_belongs_to_many',
                name: 'teams'
              },
              {
                type: 'has_and_belongs_to_many',
                name: 'permissions'
              }
            ],
            attributes: [
              id: 'd46f9336-d17e-4840-bd90-c36c8b44ca6d',
              name: 'fees',
              type: 'percentage'
            ]
          }
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation, :count).by(9)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_create_join_table_portfolios_roles_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_create_join_table_permissions_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Portfolio.new).to respond_to(:roles)
        expect(BrokerageAccount.new).to respond_to(:roles)
        expect(BrokerageAccount.new).to respond_to(:permissions)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and change(Translation.with_deleted, :count).by(-9)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_drop_join_table_portfolios_roles_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_drop_join_table_permissions_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Portfolio.new).not_to respond_to(:roles)
        expect(BrokerageAccount.new).not_to respond_to(:roles)
        expect(BrokerageAccount.new).not_to respond_to(:permissions)
      end
    end

    context 'when removing a habtm association with STI' do
      let(:initial_data) { initial_sti_data }
      let(:resource) { BrokerageAccount.create!(fees: 2.0, users: [user], teams: [teams.first]) }
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'portfolio',
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
            attributes: [
              id: 'd46f9336-d17e-4840-bd90-c36c8b44ca6d',
              name: 'fees',
              type: 'percentage'
            ]
          }
        ]
      end

      before { [migrate_initial_migration, resource] }

      after { [rollback_initial_migration, rollback_user_transaction] }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation.with_deleted, :count).by(-9)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).to be_attached
        expect(Dir[root.join('storage/migrate/*_drop_join_table_portfolios_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_drop_join_table_portfolios_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Portfolio.new).not_to respond_to(:users)
        expect(BrokerageAccount.new).not_to respond_to(:users)
        expect(BrokerageAccount.new).not_to respond_to(:teams)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation, :count).by(9)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_create_join_table_portfolios_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_create_join_table_portfolios_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Portfolio.new).to respond_to(:users)
        expect(BrokerageAccount.new).to respond_to(:users)
        expect(BrokerageAccount.new).to respond_to(:teams)
        expect(resource.reload.users.first.as_json).to eq(user.as_json)
        expect(resource.reload.teams.first.as_json).to eq(teams.first.as_json)
      end
    end

    context 'when renaming an attribute with STI' do
      let(:initial_data) { initial_sti_data }
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
              name: 'charges',
              type: 'percentage'
            ]
          }
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_rename_fees_to_charges_in_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Portfolio.new).not_to respond_to(:fees)
        expect(Portfolio.new).to respond_to(:charges)
        expect(BrokerageAccount.new).not_to respond_to(:fees)
        expect(BrokerageAccount.new).to respond_to(:charges)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_rename_charges_to_fees_in_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Portfolio.new).to respond_to(:fees)
        expect(Portfolio.new).not_to respond_to(:charges)
        expect(BrokerageAccount.new).to respond_to(:fees)
        expect(BrokerageAccount.new).not_to respond_to(:charges)
      end
    end

    context 'when changing attribute type with STI' do
      let(:initial_data) { initial_sti_data }
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
              type: 'text'
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
              type: 'integer'
            ]
          }
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_change_name_column_string_in_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_change_fees_column_float_in_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_change_name_column_text_in_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_change_fees_column_integer_in_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
      end
    end

    context 'when changing attribute uniqueness with STI' do
      let(:initial_data) { initial_sti_data }
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
              type: 'string',
              options: {
                unique: true
              }
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
          }
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_change_name_index_in_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_change_name_index_in_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
      end
    end

    context 'with a more complex scenario and STI' do
      let(:initial_data) { initial_sti_data }
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
              name: 'designation',
              type: 'string'
            ]
          },
          {
            id: '5311570e-b976-410d-b5d9-48eb928c8fb1',
            name: 'investment_account',
            options: {
              parent: 'stock_portfolio'
            },
            associations: [
              type: 'has_and_belongs_to_many',
              name: 'teams'
            ],
            attributes: [
              id: 'd46f9336-d17e-4840-bd90-c36c8b44ca6d',
              name: 'charges',
              type: 'percentage'
            ]
          }
        ]
      end

      before { migrate_initial_migration }

      after { rollback_initial_migration }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('storage/migrate/*_rename_portfolios_to_stock_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_portfolios_users_to_stock_portfolios_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_portfolio_id_to_stock_portfolio_id_in_stock_portfolios_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_name_to_designation_in_stock_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_portfolios_teams_to_stock_portfolios_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_portfolio_id_to_stock_portfolio_id_in_stock_portfolios_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_fees_to_charges_in_stock_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Portfolio }.to raise_error(NameError)
        expect { BrokerageAccount }.to raise_error(NameError)
        expect { StockPortfolio }.not_to raise_error
        expect { InvestmentAccount }.not_to raise_error
        expect(StockPortfolio.new).not_to respond_to(:name)
        expect(StockPortfolio.new).to respond_to(:designation)
        expect(InvestmentAccount.new).not_to respond_to(:fees)
        expect(InvestmentAccount.new).to respond_to(:charges)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('storage/migrate/*_rename_stock_portfolios_to_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_stock_portfolios_users_to_portfolios_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_stock_portfolio_id_to_portfolio_id_in_portfolios_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_designation_to_name_in_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_stock_portfolios_teams_to_portfolios_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_stock_portfolio_id_to_portfolio_id_in_portfolios_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('storage/migrate/*_rename_charges_to_fees_in_portfolios_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Portfolio }.not_to raise_error
        expect { BrokerageAccount }.not_to raise_error
        expect { StockPortfolio }.to raise_error(NameError)
        expect { InvestmentAccount }.to raise_error(NameError)
        expect(Portfolio.new).to respond_to(:name)
        expect(Portfolio.new).not_to respond_to(:designation)
        expect(BrokerageAccount.new).to respond_to(:fees)
        expect(BrokerageAccount.new).not_to respond_to(:charges)
      end
    end
  end
end
