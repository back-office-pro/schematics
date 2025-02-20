# Copyright © 2025 Dev & Software. All rights reserved.
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
      {
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
          }
        ]
      }
    ]
  end
  let(:migrate_prospect_entity) do
    Dir.chdir(root) { described_class.call(migration: initial_migration) }
  end
  let(:rollback_prospect_entity) do
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
        expect(Dir[root.join('db/migrate/*_create_prospects_*.rb')]).not_to be_empty
        expect(Dir[root.join('db/migrate/*_create_join_table_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Prospect }.not_to raise_error
        # rollback
        expect { expect(rollback).to be_a_success }
          .to change(Permission.with_deleted, :count).by(-6)
          .and change(Translation.with_deleted, :count).by(-15)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('db/migrate/*_drop_prospects_*.rb')]).not_to be_empty
        expect(Dir[root.join('db/migrate/*_drop_join_table_prospects_users_*.rb')]).not_to be_empty
        expect { Prospect }.to raise_error(NameError)
      end
    end

    context 'when renaming an entity' do
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'client',
            associations: [
              type: 'has_and_belongs_to_many',
              name: 'users'
            ],
            attributes: [
              {
                id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
                name: 'first_name',
                type: 'string'
              }
            ]
          }
        ]
      end

      before { migrate_prospect_entity }

      after { rollback_prospect_entity }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('db/migrate/*_rename_prospects_to_clients_*.rb')]).not_to be_empty
        expect(Dir[root.join('db/migrate/*_rename_prospects_users_to_clients_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('db/migrate/*_rename_prospect_id_to_client_id_in_clients_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Prospect }.to raise_error(NameError)
        expect { Client }.not_to raise_error
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('db/migrate/*_rename_clients_to_prospects_*.rb')]).not_to be_empty
        expect(Dir[root.join('db/migrate/*_rename_clients_users_to_prospects_users*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('db/migrate/*_rename_client_id_to_prospect_id_in_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Prospect }.not_to raise_error
        expect { Client }.to raise_error(NameError)
      end
    end

    context 'when destroying an entity' do
      let(:prospect) { Prospect.create!(first_name: 'John') }
      let(:data) { [] }

      before { [migrate_prospect_entity, prospect] }

      after { rollback_prospect_entity }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to change(Permission.with_deleted, :count).by(-6)
          .and change(Translation.with_deleted, :count).by(-15)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).to be_attached
        expect(Dir[root.join('db/migrate/*_drop_prospects_*.rb')]).not_to be_empty
        expect(Dir[root.join('db/migrate/*_drop_join_table_prospects_users_*.rb')]).not_to be_empty
        expect { Prospect }.to raise_error(NameError)
        expect { prospect.reload }.to raise_error(ActiveRecord::StatementInvalid)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to change(Permission, :count).by(6)
          .and change(Translation, :count).by(15)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('db/migrate/*_create_prospects_*.rb')]).not_to be_empty
        expect(Dir[root.join('db/migrate/*_create_join_table_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Prospect }.not_to raise_error
        expect { prospect.reload }.not_to raise_error
      end
    end

    context 'when adding a new attribute' do
      let(:data) do
        [
          {
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
          }
        ]
      end

      before { migrate_prospect_entity }

      after { rollback_prospect_entity }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation, :count).by(3)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('db/migrate/*_add_last_name_to_prospects_*.rb')]).not_to be_empty
        expect(Prospect.new).to respond_to(:last_name)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and change(Translation.with_deleted, :count).by(-3)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('db/migrate/*_remove_last_name_from_prospects_*.rb')]).not_to be_empty
        expect(Prospect.new).not_to respond_to(:last_name)
      end
    end

    context 'when removing an attribute' do
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'prospect',
            associations: [
              type: 'has_and_belongs_to_many',
              name: 'users'
            ]
          }
        ]
      end

      before { migrate_prospect_entity }

      after { rollback_prospect_entity }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation.with_deleted, :count).by(-3)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('db/migrate/*_remove_first_name_from_prospects_*.rb')]).not_to be_empty
        expect(Prospect.new).not_to respond_to(:first_name)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and change(Translation, :count).by(3)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('db/migrate/*_add_first_name_to_prospects_*.rb')]).not_to be_empty
        expect(Prospect.new).to respond_to(:first_name)
      end
    end

    context 'when adding a new belongs_to association' do
      let(:data) do
        [
          {
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
          }
        ]
      end

      before { migrate_prospect_entity }

      after { rollback_prospect_entity }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation, :count).by(3)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('db/migrate/*_add_user_to_prospects_*.rb')]).not_to be_empty
        expect(Prospect.new).to respond_to(:user)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and change(Translation.with_deleted, :count).by(-3)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('db/migrate/*_remove_user_from_prospects_*.rb')]).not_to be_empty
        expect(Prospect.new).not_to respond_to(:user)
      end
    end

    context 'when adding a new habtm association' do
      let(:data) do
        [
          {
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
              {
                id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
                name: 'first_name',
                type: 'string'
              }
            ]
          }
        ]
      end

      before { migrate_prospect_entity }

      after { rollback_prospect_entity }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation, :count).by(3)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('db/migrate/*_create_join_table_prospects_teams_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Prospect.new).to respond_to(:teams)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and change(Translation.with_deleted, :count).by(-3)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('db/migrate/*_drop_join_table_prospects_teams_*.rb')]).not_to be_empty
        expect(Prospect.new).not_to respond_to(:teams)
      end
    end

    context 'when removing a habtm association' do
      let(:prospect) { Prospect.create!(first_name: 'John', users: [user]) }
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'prospect',
            attributes: [
              {
                id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
                name: 'first_name',
                type: 'string'
              }
            ]
          }
        ]
      end

      before { [migrate_prospect_entity, prospect] }

      after { [rollback_prospect_entity, rollback_user_transaction] }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation.with_deleted, :count).by(-3)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).to be_attached
        expect(Dir[root.join('db/migrate/*_drop_join_table_prospects_users_*.rb')]).not_to be_empty
        expect(Prospect.new).not_to respond_to(:users)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission, :count)
          .and change(Translation, :count).by(3)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('db/migrate/*_create_join_table_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Prospect.new).to respond_to(:users)
        expect(prospect.reload.users).to eq([user])
      end
    end

    context 'when renaming an attribute' do
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'prospect',
            associations: [
              {
                name: 'users',
                type: 'has_and_belongs_to_many'
              }
            ],
            attributes: [
              {
                id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
                name: 'surname',
                type: 'string'
              }
            ]
          }
        ]
      end

      before { migrate_prospect_entity }

      after { rollback_prospect_entity }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('db/migrate/*_rename_first_name_to_surname_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Prospect.new).not_to respond_to(:first_name)
        expect(Prospect.new).to respond_to(:surname)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('db/migrate/*_rename_surname_to_first_name_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Prospect.new).to respond_to(:first_name)
        expect(Prospect.new).not_to respond_to(:surname)
      end
    end

    context 'when changing attribute type' do
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'prospect',
            associations: [
              {
                name: 'users',
                type: 'has_and_belongs_to_many'
              }
            ],
            attributes: [
              {
                id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
                name: 'first_name',
                type: 'text'
              }
            ]
          }
        ]
      end

      before { migrate_prospect_entity }

      after { rollback_prospect_entity }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('db/migrate/*_change_first_name_column_string_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('db/migrate/*_change_first_name_column_text_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
      end
    end

    context 'when changing attribute uniqueness' do
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'prospect',
            associations: [
              {
                name: 'users',
                type: 'has_and_belongs_to_many'
              }
            ],
            attributes: [
              {
                id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
                name: 'first_name',
                type: 'string',
                options: {
                  unique: true
                }
              }
            ]
          }
        ]
      end

      before { migrate_prospect_entity }

      after { rollback_prospect_entity }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('db/migrate/*_change_first_name_index_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('db/migrate/*_change_first_name_index_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
      end
    end

    context 'with a more complex scenario' do
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'client',
            associations: [
              {
                name: 'users',
                type: 'has_and_belongs_to_many'
              }
            ],
            attributes: [
              {
                id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
                name: 'surname',
                type: 'string'
              }
            ]
          }
        ]
      end

      before { migrate_prospect_entity }

      after { rollback_prospect_entity }

      uses_transaction 'migrates and rollbacks successfully'

      it 'migrates and rollbacks successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        # migrate
        expect { expect(migrate).to be_a_success }
          .to not_change(Permission, :count)
          .and not_change(Translation, :count)
          .and change(Documentation, :count).by(1)
        expect(migration.backup).not_to be_attached
        expect(Dir[root.join('db/migrate/*_rename_prospects_to_clients_*.rb')]).not_to be_empty
        expect(Dir[root.join('db/migrate/*_rename_prospects_users_to_clients_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('db/migrate/*_rename_prospect_id_to_client_id_in_clients_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('db/migrate/*_rename_first_name_to_surname_in_clients_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect { Prospect }.to raise_error(NameError)
        expect { Client }.not_to raise_error
        expect(Client.new).not_to respond_to(:first_name)
        expect(Client.new).to respond_to(:surname)
        # rollback
        expect { expect(rollback).to be_a_success }
          .to not_change(Permission.with_deleted, :count)
          .and not_change(Translation.with_deleted, :count)
          .and change(Documentation.with_deleted, :count).by(-1)
        expect(Dir[root.join('db/migrate/*_rename_clients_to_prospects_*.rb')]).not_to be_empty
        expect(Dir[root.join('db/migrate/*_rename_clients_users_to_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('db/migrate/*_rename_client_id_to_prospect_id_in_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Dir[root.join('db/migrate/*_rename_surname_to_first_name_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
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
  end
end
