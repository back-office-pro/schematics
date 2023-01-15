# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::SchemaDatasets::Migrate do
  self.use_transactional_tests = false

  let(:schema_dataset) { SchemaDataset.new(data:, state: :in_progress) }
  let(:schema) { Schematics::Schema.new(data: current_data) }
  let(:admin_role) { Role.find_or_create_by!(name: 'Admin') }
  let(:root) { Rails.root }

  before do
    admin_role
    Tenant.schema = schema
    allow(schema_dataset).to receive(:valid?).and_return(true)
  end

  describe '.call' do
    subject(:call) { described_class.call(schema_dataset:) }

    let(:rollback_commit) { Git.init(root).reset_hard('HEAD~1') }
    let(:rollback_migration) do
      Dir.chdir(root) do
        ActiveRecord::Base.connection.migration_context.rollback(migrations_steps)
      end
    end
    let(:rollback_reload) do
      schema_dataset.migration_new_entities.each do |entity|
        Object.__send__(:remove_const, entity.class_name.to_sym)
        Object.__send__(:remove_const, :"#{entity.class_name.pluralize}Controller".to_sym)
      end
      schema_dataset.migration_old_entities.each do |entity|
        load Rails.root.join('app', 'models', "#{entity.name}.rb")
        load Rails.root.join('app', 'controllers', "#{entity.name.pluralize}_controller.rb")
      end
    end

    before do
      Dir.chdir(root) { call }
    end

    after { [rollback_migration, rollback_commit, rollback_reload] }

    context 'when creating a new entity' do
      let(:migrations_steps) { 4 }
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

      it { is_expected.to be_a_success }

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
    end

    context 'when renaming an entity' do
      let(:migrations_steps) { 1 }
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

      it { is_expected.to be_a_success }

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
    end

    context 'when destroying an entity' do
      let(:migrations_steps) { 1 }
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

      it { is_expected.to be_a_success }

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
    end

    context 'when adding a new attribute' do
      let(:migrations_steps) { 1 }
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

      it { is_expected.to be_a_success }

      it 'creates a migration file' do
        expect(Dir[root.join('db/migrate/*_add_age_to_users.rb')]).not_to be_empty
      end
    end

    context 'when removing an attribute' do
      let(:migrations_steps) { 1 }
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

      it { is_expected.to be_a_success }

      it 'creates a migration file' do
        expect(Dir[root.join('db/migrate/*_remove_last_name_from_users.rb')]).not_to be_empty
      end
    end

    context 'when renaming an attribute' do
      let(:migrations_steps) { 1 }
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

      it { is_expected.to be_a_success }

      it 'creates a migration file' do
        expect(Dir[root.join('db/migrate/*_rename_last_name_to_surname_in_users.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
      end
    end
  end
end
