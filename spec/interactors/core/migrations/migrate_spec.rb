# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Migrations::Migrate do
  include_context 'with google translate stub'

  let(:migration) { Migration.new(data:, state:) }
  let(:schema) { Schematics::Schema.new(data: current_data) }
  let(:current_data) { initial_data }
  let(:state) { Migration::STATE_STATE_IN_PROGRESS }
  let(:root) { Rails.root }
  let(:initial_data) do
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
  let(:create_prospect_entity) do
    Tenant.schema = Schematics::Schema.new(data: [])
    Dir.chdir(root) do
      described_class.call(migration: Migration.new(data: initial_data, state:))
    end
  end
  let(:rollback_commit) { Git.init(root).reset_hard("HEAD~#{commits_steps}") }
  let(:rollback_transaction) { [Permission, Translation].each(&:delete_all) }
  let(:rollback_migration) do
    Dir.chdir(root) do
      ActiveRecord::Base.connection.migration_context.rollback(migrations_steps)
    end
  end
  let(:rollback_reload) do
    Object.__send__(:remove_const, :Prospect)
    Object.__send__(:remove_const, :ProspectsController)
  end

  before do
    Tenant.schema = schema
    allow(Role).to receive(:admin).and_return(Role.new)
    allow(migration).to receive_messages(valid?: true, previously_migrated_schema: schema)
  end

  after { [rollback_migration, rollback_commit, rollback_reload, rollback_transaction] }

  describe '.call' do
    subject(:migrate) { Dir.chdir(root) { described_class.call(migration:) } }

    context 'when creating a new entity' do
      let(:current_data) { [] }
      let(:data) { initial_data }
      let(:commits_steps) { 1 }
      let(:migrations_steps) { 1 }

      uses_transaction 'migrates successfully'

      it 'migrates successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        expect { expect(migrate).to be_a_success }
          .to change(Permission, :count).by(6)
          .and change(Translation, :count).by(12)
        expect(Dir[root.join('db/migrate/*_create_prospects_*.rb')]).not_to be_empty
        expect(File).to exist root.join('app/models/prospect.rb')
        expect(File).to exist root.join('app/controllers/prospects_controller.rb')
        expect(File).to exist root.join('spec/models/prospect_spec.rb')
        expect(File).to exist root.join('spec/features/prospect_spec.rb')
        expect { Prospect }.not_to raise_error
      end
    end

    context 'when renaming an entity' do
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'client',
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
      let(:commits_steps) { 2 }
      let(:migrations_steps) { 2 }
      let(:rollback_reload) do
        Object.__send__(:remove_const, :Client)
        Object.__send__(:remove_const, :ClientsController)
      end

      before { create_prospect_entity }

      uses_transaction 'migrates successfully'

      it 'migrates successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        expect(migrate).to be_a_success
        expect(Dir[root.join('db/migrate/*_rename_prospects_to_clients_*.rb')]).not_to be_empty
        expect(File).not_to exist root.join('app/models/prospect.rb')
        expect(File).not_to exist root.join('app/controllers/prospects_controller.rb')
        expect(File).not_to exist root.join('spec/models/prospect_spec.rb')
        expect(File).not_to exist root.join('spec/features/prospect_spec.rb')
        expect(File).to exist root.join('app/models/client.rb')
        expect(File).to exist root.join('app/controllers/clients_controller.rb')
        expect(File).to exist root.join('spec/models/client_spec.rb')
        expect(File).to exist root.join('spec/features/client_spec.rb')
        expect { Prospect }.to raise_error(NameError)
        expect { Client }.not_to raise_error
      end
    end

    context 'when destroying an entity' do
      let(:data) { [] }
      let(:commits_steps) { 2 }
      let(:migrations_steps) { 2 }
      let(:rollback_reload) { nil }

      before { create_prospect_entity }

      uses_transaction 'migrates successfully'

      it 'migrates successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        expect { expect(migrate).to be_a_success }
          .to change(Permission, :count).by(-6)
          .and change(Translation, :count).by(-12)
        expect(Dir[root.join('db/migrate/*_drop_prospects_*.rb')]).not_to be_empty
        expect(File).not_to exist root.join('app/models/prospect.rb')
        expect(File).not_to exist root.join('app/controllers/prospects_controller.rb')
        expect(File).not_to exist root.join('spec/models/prospect_spec.rb')
        expect(File).not_to exist root.join('spec/features/prospect_spec.rb')
        expect { Prospect }.to raise_error(NameError)
      end
    end

    context 'when adding a new attribute' do
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
      let(:commits_steps) { 2 }
      let(:migrations_steps) { 2 }

      before { create_prospect_entity }

      uses_transaction 'migrates successfully'

      it 'migrates successfully' do # rubocop:disable RSpec/MultipleExpectations
        expect { expect(migrate).to be_a_success }.to change(Translation, :count).by(3)
        expect(Dir[root.join('db/migrate/*_add_last_name_to_prospects_*.rb')]).not_to be_empty
        expect(Prospect.new).to respond_to(:last_name)
      end
    end

    context 'when removing an attribute' do
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'prospect'
          }
        ]
      end
      let(:commits_steps) { 2 }
      let(:migrations_steps) { 2 }

      before { create_prospect_entity }

      uses_transaction 'migrates successfully'

      it 'migrates successfully' do # rubocop:disable RSpec/MultipleExpectations
        expect { expect(migrate).to be_a_success }.to change(Translation, :count).by(-3)
        expect(Dir[root.join('db/migrate/*_remove_first_name_from_prospects_*.rb')]).not_to be_empty
        expect(Prospect.new).not_to respond_to(:first_name)
      end
    end

    context 'when adding a new belongs_to association' do
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
      let(:commits_steps) { 2 }
      let(:migrations_steps) { 2 }

      before { create_prospect_entity }

      uses_transaction 'migrates successfully'

      it 'migrates successfully' do # rubocop:disable RSpec/MultipleExpectations
        expect { expect(migrate).to be_a_success }.to change(Translation, :count).by(3)
        expect(Dir[root.join('db/migrate/*_add_user_to_prospects_*.rb')]).not_to be_empty
        expect(Prospect.new).to respond_to(:user)
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
      let(:commits_steps) { 2 }
      let(:migrations_steps) { 2 }

      before { create_prospect_entity }

      uses_transaction 'migrates successfully'

      it 'migrates successfully' do # rubocop:disable RSpec/MultipleExpectations
        expect { expect(migrate).to be_a_success }.to change(Translation, :count).by(3)
        expect(Dir[root.join('db/migrate/*_create_join_table_prospects_users_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Prospect.new).to respond_to(:users)
      end
    end

    context 'when renaming an attribute' do
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'prospect',
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
      let(:commits_steps) { 2 }
      let(:migrations_steps) { 2 }

      before { create_prospect_entity }

      uses_transaction 'migrates successfully'

      it 'migrates successfully' do # rubocop:disable RSpec/MultipleExpectations,
        expect(migrate).to be_a_success
        expect(Dir[root.join('db/migrate/*_rename_first_name_to_surname_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(Prospect.new).not_to respond_to(:first_name)
        expect(Prospect.new).to respond_to(:surname)
      end
    end

    context 'when changing attribute type' do
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'prospect',
            attributes: [
              {
                id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
                name: 'first_name',
                type: 'citext'
              }
            ]
          }
        ]
      end
      let(:commits_steps) { 2 }
      let(:migrations_steps) { 2 }

      before { create_prospect_entity }

      uses_transaction 'migrates successfully'

      it 'migrates successfully' do # rubocop:disable RSpec/MultipleExpectations
        expect(migrate).to be_a_success
        expect(Dir[root.join('db/migrate/*_change_first_name_column_string_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
      end
    end

    context 'when changing attribute uniqueness' do
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'prospect',
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
      let(:commits_steps) { 2 }
      let(:migrations_steps) { 2 }

      before { create_prospect_entity }

      uses_transaction 'migrates successfully'

      it 'migrates successfully' do # rubocop:disable RSpec/MultipleExpectations
        expect(migrate).to be_a_success
        expect(Dir[root.join('db/migrate/*_change_first_name_index_in_prospects_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
      end
    end

    context 'with a more complex scenario' do
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'client',
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
      let(:commits_steps) { 2 }
      let(:migrations_steps) { 3 }
      let(:rollback_reload) do
        Object.__send__(:remove_const, :Client)
        Object.__send__(:remove_const, :ClientsController)
      end

      before { create_prospect_entity }

      uses_transaction 'migrates successfully'

      it 'migrates successfully' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
        expect(migrate).to be_a_success
        expect(Dir[root.join('db/migrate/*_rename_prospects_to_clients_*.rb')]).not_to be_empty
        expect(Dir[root.join('db/migrate/*_rename_first_name_to_surname_in_clients_*.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
        expect(File).not_to exist root.join('app/models/prospect.rb')
        expect(File).not_to exist root.join('app/controllers/prospects_controller.rb')
        expect(File).not_to exist root.join('spec/models/prospect_spec.rb')
        expect(File).not_to exist root.join('spec/features/prospect_spec.rb')
        expect(File).to exist root.join('app/models/client.rb')
        expect(File).to exist root.join('app/controllers/clients_controller.rb')
        expect(File).to exist root.join('spec/models/client_spec.rb')
        expect(File).to exist root.join('spec/features/client_spec.rb')
        expect { Prospect }.to raise_error(NameError)
        expect { Client }.not_to raise_error
        expect(Client.new).not_to respond_to(:first_name)
        expect(Client.new).to respond_to(:surname)
      end
    end

    context 'when migrating core' do
      let(:migration) { Migration.core }
      let(:commits_steps) { 0 }
      let(:migrations_steps) { 0 }
      let(:rollback_reload) { nil }

      uses_transaction 'migrates successfully'

      it 'migrates successfully' do
        expect(migrate).to be_a_success
      end
    end
  end
end
