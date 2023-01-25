# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::SchemaDatasets::Migrate do
  let(:schema_dataset) { SchemaDataset.new(data:, state: :in_progress) }
  let(:schema) { Schematics::Schema.new(data: current_data) }
  let(:admin_role) { Role.find_or_create_by!(name: 'Admin') }

  before do
    admin_role
    Tenant.schema = schema
    allow(schema_dataset).to receive(:valid?).and_return(true)
  end

  describe '.call', skip: 'must be run standalone' do
    subject(:call) { described_class.call(schema_dataset:) }

    before do
      Dir.chdir(root) { call }
    end

    context 'when creating a new entity' do
      let(:current_data) { [] }
      let(:data) do
        [
          {
            name: 'prospect',
            attributes: [
              {
                name: 'name',
                type: 'string'
              }
            ]
          }
        ]
      end

      include_context 'with application migration rollback', 4

      uses_transaction 'is a success'
      uses_transaction 'creates a migration file'
      uses_transaction 'creates a slug migration file'
      uses_transaction 'creates a lock_version migration file'
      uses_transaction 'creates a counter cache migration file'
      uses_transaction 'creates a model file'
      uses_transaction 'creates a controller file'
      uses_transaction 'creates a rspec model file'
      uses_transaction 'creates a serializer file'
      uses_transaction 'creates a rspec feature file'
      uses_transaction 'defines a model class'

      it 'is a success' do
        expect(call).to be_a_success
      end

      it 'creates a migration file' do
        expect(Dir[root.join('db/migrate/*_create_prospects.rb')]).not_to be_empty
      end

      it 'creates a slug migration file' do
        expect(Dir[root.join('db/migrate/*_add_slug_to_prospects.rb')]).not_to be_empty
      end

      it 'creates a lock_version migration file' do
        expect(Dir[root.join('db/migrate/*_add_lock_version_to_prospects.rb')]).not_to be_empty
      end

      it 'creates a counter cache migration file' do
        expect(Dir[root.join('db/migrate/*_add_comments_count_to_prospects.rb')]).not_to be_empty
      end

      it 'creates a model file' do
        expect(File).to exist root.join('app/models/prospect.rb')
      end

      it 'creates a controller file' do
        expect(File).to exist root.join('app/controllers/prospects_controller.rb')
      end

      it 'creates a rspec model file' do
        expect(File).to exist root.join('spec/models/prospect_spec.rb')
      end

      it 'creates a serializer file' do
        expect(File).to exist root.join('app/serializers/prospect_serializer.rb')
      end

      it 'creates a rspec feature file' do
        expect(File).to exist root.join('spec/features/prospect_spec.rb')
      end

      it 'defines a model class' do
        expect { Prospect }.not_to raise_error
      end
    end

    context 'when renaming an entity' do
      let(:current_data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'user',
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

      include_context 'with application migration rollback'

      uses_transaction 'is a success'
      uses_transaction 'destroys the model file'
      uses_transaction 'destroys the controller file'
      uses_transaction 'destroys the rspec model file'
      uses_transaction 'destroys the serializer file'
      uses_transaction 'destroys the rspec feature file'
      uses_transaction 'creates a migration file'
      uses_transaction 'creates a model file'
      uses_transaction 'creates a controller file'
      uses_transaction 'creates a rspec model file'
      uses_transaction 'creates a serializer file'
      uses_transaction 'creates a rspec feature file'
      uses_transaction 'undefines a model class'
      uses_transaction 'defines a model class'

      it 'is a success' do
        expect(call).to be_a_success
      end

      it 'destroys the model file' do
        expect(File).not_to exist root.join('app/models/user.rb')
      end

      it 'destroys the controller file' do
        expect(File).not_to exist root.join('app/controllers/users_controller.rb')
      end

      it 'destroys the rspec model file' do
        expect(File).not_to exist root.join('spec/models/user_spec.rb')
      end

      it 'destroys the serializer file' do
        expect(File).not_to exist root.join('app/serializers/user_serializer.rb')
      end

      it 'destroys the rspec feature file' do
        expect(File).not_to exist root.join('spec/features/user_spec.rb')
      end

      it 'creates a migration file' do
        expect(Dir[root.join('db/migrate/*_rename_users_to_clients.rb')]).not_to be_empty
      end

      it 'creates a model file' do
        expect(File).to exist root.join('app/models/client.rb')
      end

      it 'creates a controller file' do
        expect(File).to exist root.join('app/controllers/clients_controller.rb')
      end

      it 'creates a rspec model file' do
        expect(File).to exist root.join('spec/models/client_spec.rb')
      end

      it 'creates a serializer file' do
        expect(File).to exist root.join('app/serializers/client_serializer.rb')
      end

      it 'creates a rspec feature file' do
        expect(File).to exist root.join('spec/features/client_spec.rb')
      end

      it 'undefines a model class' do
        expect { User }.to raise_error(NameError)
      end

      it 'defines a model class' do
        expect { Client }.not_to raise_error
      end
    end

    context 'when destroying an entity' do
      let(:data) { [] }
      let(:current_data) do
        [
          {
            name: 'user',
            attributes: [
              {
                name: 'first_name',
                type: 'string'
              },
              {
                name: 'last_name',
                type: 'string'
              }
            ]
          }
        ]
      end

      include_context 'with application migration rollback'

      uses_transaction 'is a success'
      uses_transaction 'creates a migration file'
      uses_transaction 'destroys the model file'
      uses_transaction 'destroys the controller file'
      uses_transaction 'destroys the rspec model file'
      uses_transaction 'destroys the serializer file'
      uses_transaction 'destroys the rspec feature file'
      uses_transaction 'undefines a model class'

      it 'is a success' do
        expect(call).to be_a_success
      end

      it 'creates a migration file' do
        expect(Dir[root.join('db/migrate/*_drop_users.rb')]).not_to be_empty
      end

      it 'destroys the model file' do
        expect(File).not_to exist root.join('app/models/user.rb')
      end

      it 'destroys the controller file' do
        expect(File).not_to exist root.join('app/controllers/users_controller.rb')
      end

      it 'destroys the rspec model file' do
        expect(File).not_to exist root.join('spec/models/user_spec.rb')
      end

      it 'destroys the serializer file' do
        expect(File).not_to exist root.join('app/serializers/user_serializer.rb')
      end

      it 'destroys the rspec feature file' do
        expect(File).not_to exist root.join('spec/features/user_spec.rb')
      end

      it 'undefines a model class' do
        expect { User }.to raise_error(NameError)
      end
    end

    context 'when adding a new attribute' do
      let(:current_data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'user',
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
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'user',
            attributes: [
              {
                id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
                name: 'first_name',
                type: 'string'
              },
              {
                id: 'd46f9336-d17e-4840-bd90-c36c8b44ca6d',
                name: 'age',
                type: 'integer'
              }
            ]
          }
        ]
      end

      include_context 'with application migration rollback'

      uses_transaction 'is a success'
      uses_transaction 'creates a migration file'
      uses_transaction 'responds to new model attribute'

      it 'is a success' do
        expect(call).to be_a_success
      end

      it 'creates a migration file' do
        expect(Dir[root.join('db/migrate/*_add_age_to_users.rb')]).not_to be_empty
      end

      it 'responds to new model attribute' do
        expect(User.new).to respond_to(:age)
      end
    end

    context 'when removing an attribute' do
      let(:current_data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'user',
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
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'user',
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

      include_context 'with application migration rollback'

      uses_transaction 'is a success'
      uses_transaction 'creates a migration file'

      it 'is a success' do
        expect(call).to be_a_success
      end

      it 'creates a migration file' do
        expect(Dir[root.join('db/migrate/*_remove_last_name_from_users.rb')]).not_to be_empty
      end
    end

    context 'when renaming an attribute' do
      let(:current_data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'user',
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
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'user',
            attributes: [
              {
                id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
                name: 'first_name',
                type: 'string'
              },
              {
                id: 'd46f9336-d17e-4840-bd90-c36c8b44ca6d',
                name: 'surname',
                type: 'string'
              }
            ]
          }
        ]
      end

      include_context 'with application migration rollback'

      uses_transaction 'is a success'
      uses_transaction 'creates a migration file'
      uses_transaction 'responds to new model attribute'

      it 'is a success' do
        expect(call).to be_a_success
      end

      it 'creates a migration file' do
        expect(Dir[root.join('db/migrate/*_rename_last_name_to_surname_in_users.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
      end

      it 'responds to new model attribute' do
        expect(User.new).to respond_to(:surname)
      end
    end
  end
end
