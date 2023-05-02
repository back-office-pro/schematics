# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::SchemaDatasets::Migrate do
  let(:schema_dataset) { SchemaDataset.new(data:, state:) }
  let(:schema) { Schematics::Schema.new(data: current_data) }
  let(:current_data) { initial_data }
  let(:state) { :in_progress }
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
      described_class.call(schema_dataset: SchemaDataset.new(data: initial_data, state:))
    end
  end
  let(:rollback_commit) { Git.init(root).reset_hard("HEAD~#{commits_steps}") }
  let(:rollback_migration) do
    Dir.chdir(root) do
      ActiveRecord::Base.connection.migration_context.rollback(migrations_steps)
    end
  end

  before do
    Tenant.schema = schema
    allow(Role).to receive(:admin).and_return(Role.new)
    allow(schema_dataset).to receive(:valid?).and_return(true)
  end

  after { [rollback_migration, rollback_commit, rollback_reload] }

  describe '.call' do
    subject(:migrate) { Dir.chdir(root) { described_class.call(schema_dataset:) } }

    context 'when creating a new entity' do
      let(:current_data) { [] }
      let(:data) { initial_data }
      let(:commits_steps) { 1 }
      let(:migrations_steps) { 1 }
      let(:rollback_reload) do
        schema_dataset.migration_new_and_changed_entities.each do |entity|
          Object.__send__(:remove_const, entity.class_name.to_sym)
          Object.__send__(:remove_const, :"#{entity.class_name.pluralize}Controller".to_sym)
        end
        schema_dataset.migration_old_and_changed_entities.each do |entity|
          load root.join('app', 'models', "#{entity.name}.rb")
          load root.join('app', 'controllers', "#{entity.name.pluralize}_controller.rb")
        end
      end

      uses_transaction 'is a success'
      uses_transaction 'creates a migration file'
      uses_transaction 'creates a model file'
      uses_transaction 'creates a controller file'
      uses_transaction 'creates a rspec model file'
      uses_transaction 'creates a rspec feature file'
      uses_transaction 'creates permissions'
      uses_transaction 'creates translations'
      uses_transaction 'defines a model class'

      it 'is a success' do
        expect(migrate).to be_a_success
      end

      it 'creates a migration file' do
        migrate
        expect(Dir[root.join('db/migrate/*_create_prospects.rb')]).not_to be_empty
      end

      it 'creates a model file' do
        migrate
        expect(File).to exist root.join('app/models/prospect.rb')
      end

      it 'creates a controller file' do
        migrate
        expect(File).to exist root.join('app/controllers/prospects_controller.rb')
      end

      it 'creates a rspec model file' do
        migrate
        expect(File).to exist root.join('spec/models/prospect_spec.rb')
      end

      it 'creates a rspec feature file' do
        migrate
        expect(File).to exist root.join('spec/features/prospect_spec.rb')
      end

      it 'creates permissions' do
        expect { migrate }.to change(Permission, :count).by(6)
      end

      it 'creates translations' do
        expect { migrate }.to change(Translation, :count).by(8)
      end

      it 'defines a model class' do
        migrate
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
        schema_dataset.migration_new_and_changed_entities.each do |entity|
          Object.__send__(:remove_const, entity.class_name.to_sym)
          Object.__send__(:remove_const, :"#{entity.class_name.pluralize}Controller".to_sym)
        end
      end

      before { create_prospect_entity }

      uses_transaction 'is a success'
      uses_transaction 'destroys the model file'
      uses_transaction 'destroys the controller file'
      uses_transaction 'destroys the rspec model file'
      uses_transaction 'destroys the rspec feature file'
      uses_transaction 'creates a migration file'
      uses_transaction 'creates a model file'
      uses_transaction 'creates a controller file'
      uses_transaction 'creates a rspec model file'
      uses_transaction 'creates a rspec feature file'
      uses_transaction 'undefines a model class'
      uses_transaction 'defines a model class'

      it 'is a success' do
        expect(migrate).to be_a_success
      end

      it 'destroys the model file' do
        migrate
        expect(File).not_to exist root.join('app/models/prospect.rb')
      end

      it 'destroys the controller file' do
        migrate
        expect(File).not_to exist root.join('app/controllers/prospects_controller.rb')
      end

      it 'destroys the rspec model file' do
        migrate
        expect(File).not_to exist root.join('spec/models/prospect_spec.rb')
      end

      it 'destroys the rspec feature file' do
        migrate
        expect(File).not_to exist root.join('spec/features/prospect_spec.rb')
      end

      it 'creates a migration file' do
        migrate
        expect(Dir[root.join('db/migrate/*_rename_prospects_to_clients.rb')]).not_to be_empty
      end

      it 'creates a model file' do
        migrate
        expect(File).to exist root.join('app/models/client.rb')
      end

      it 'creates a controller file' do
        migrate
        expect(File).to exist root.join('app/controllers/clients_controller.rb')
      end

      it 'creates a rspec model file' do
        migrate
        expect(File).to exist root.join('spec/models/client_spec.rb')
      end

      it 'creates a rspec feature file' do
        migrate
        expect(File).to exist root.join('spec/features/client_spec.rb')
      end

      it 'undefines a model class' do
        migrate
        expect { Prospect }.to raise_error(NameError)
      end

      it 'defines a model class' do
        migrate
        expect { Client }.not_to raise_error
      end
    end

    context 'when destroying an entity' do
      let(:data) { [] }
      let(:commits_steps) { 2 }
      let(:migrations_steps) { 2 }
      let(:rollback_reload) { nil }

      before { create_prospect_entity }

      uses_transaction 'is a success'
      uses_transaction 'creates a migration file'
      uses_transaction 'destroys the model file'
      uses_transaction 'destroys the controller file'
      uses_transaction 'destroys the rspec model file'
      uses_transaction 'destroys the rspec feature file'
      uses_transaction 'destroys permissions'
      uses_transaction 'destroys translations'
      uses_transaction 'undefines a model class'

      it 'is a success' do
        expect(migrate).to be_a_success
      end

      it 'creates a migration file' do
        migrate
        expect(Dir[root.join('db/migrate/*_drop_prospects.rb')]).not_to be_empty
      end

      it 'destroys the model file' do
        migrate
        expect(File).not_to exist root.join('app/models/prospect.rb')
      end

      it 'destroys the controller file' do
        migrate
        expect(File).not_to exist root.join('app/controllers/prospects_controller.rb')
      end

      it 'destroys the rspec model file' do
        migrate
        expect(File).not_to exist root.join('spec/models/prospect_spec.rb')
      end

      it 'destroys the rspec feature file' do
        migrate
        expect(File).not_to exist root.join('spec/features/prospect_spec.rb')
      end

      it 'destroys permissions' do
        expect { migrate }.to change(Permission, :count).by(-6)
      end

      it 'destroys translations' do
        expect { migrate }.to change(Translation, :count).by(-8)
      end

      it 'undefines a model class' do
        migrate
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
      let(:rollback_reload) do
        Object.__send__(:remove_const, :Prospect)
        Object.__send__(:remove_const, :ProspectsController)
      end

      before { create_prospect_entity }

      uses_transaction 'is a success'
      uses_transaction 'creates a migration file'
      uses_transaction 'creates translations'
      uses_transaction 'responds to new model attribute'

      it 'is a success' do
        expect(migrate).to be_a_success
      end

      it 'creates a migration file' do
        migrate
        expect(Dir[root.join('db/migrate/*_add_last_name_to_prospects.rb')]).not_to be_empty
      end

      it 'creates translations' do
        expect { migrate }.to change(Translation, :count).by(2)
      end

      it 'responds to new model attribute' do
        migrate
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
      let(:rollback_reload) do
        Object.__send__(:remove_const, :Prospect)
        Object.__send__(:remove_const, :ProspectsController)
      end

      before { create_prospect_entity }

      uses_transaction 'is a success'
      uses_transaction 'creates a migration file'
      uses_transaction 'destroys translations'
      uses_transaction 'does not respond to old model attribute'

      it 'is a success' do
        expect(migrate).to be_a_success
      end

      it 'creates a migration file' do
        migrate
        expect(Dir[root.join('db/migrate/*_remove_first_name_from_prospects.rb')]).not_to be_empty
      end

      it 'destroys translations' do
        expect { migrate }.to change(Translation, :count).by(-2)
      end

      it 'does not respond to old model attribute' do
        migrate
        expect(Prospect.new).not_to respond_to(:first_name)
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
      let(:rollback_reload) do
        Object.__send__(:remove_const, :Prospect)
        Object.__send__(:remove_const, :ProspectsController)
      end

      before { create_prospect_entity }

      uses_transaction 'is a success'
      uses_transaction 'creates a migration file'
      uses_transaction 'does not respond to old model attribute'
      uses_transaction 'responds to new model attribute'

      it 'is a success' do
        expect(migrate).to be_a_success
      end

      it 'creates a migration file' do
        migrate
        expect(Dir[root.join('db/migrate/*_rename_first_name_to_surname_in_prospects.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
      end

      it 'does not respond to old model attribute' do
        migrate
        expect(Prospect.new).not_to respond_to(:first_name)
      end

      it 'responds to new model attribute' do
        migrate
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
      let(:rollback_reload) do
        Object.__send__(:remove_const, :Prospect)
        Object.__send__(:remove_const, :ProspectsController)
      end

      before { create_prospect_entity }

      uses_transaction 'is a success'
      uses_transaction 'creates a migration file'

      it 'is a success' do
        expect(migrate).to be_a_success
      end

      it 'creates a migration file' do
        migrate
        expect(Dir[root.join('db/migrate/*_change_first_name_column_string_in_prospects.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
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
        schema_dataset.migration_new_and_changed_entities.each do |entity|
          Object.__send__(:remove_const, entity.class_name.to_sym)
          Object.__send__(:remove_const, :"#{entity.class_name.pluralize}Controller".to_sym)
        end
      end

      before { create_prospect_entity }

      uses_transaction 'is a success'
      uses_transaction 'destroys the model file'
      uses_transaction 'destroys the controller file'
      uses_transaction 'destroys the rspec model file'
      uses_transaction 'destroys the rspec feature file'
      uses_transaction 'creates a rename table migration file'
      uses_transaction 'creates a rename attribute migration file'
      uses_transaction 'creates a model file'
      uses_transaction 'creates a controller file'
      uses_transaction 'creates a rspec model file'
      uses_transaction 'creates a rspec feature file'
      uses_transaction 'undefines a model class'
      uses_transaction 'defines a model class'
      uses_transaction 'does not respond to old model attribute'
      uses_transaction 'responds to new model attribute'

      it 'is a success' do
        expect(migrate).to be_a_success
      end

      it 'destroys the model file' do
        migrate
        expect(File).not_to exist root.join('app/models/prospect.rb')
      end

      it 'destroys the controller file' do
        migrate
        expect(File).not_to exist root.join('app/controllers/prospects_controller.rb')
      end

      it 'destroys the rspec model file' do
        migrate
        expect(File).not_to exist root.join('spec/models/prospect_spec.rb')
      end

      it 'destroys the rspec feature file' do
        migrate
        expect(File).not_to exist root.join('spec/features/prospect_spec.rb')
      end

      it 'creates a rename table migration file' do
        migrate
        expect(Dir[root.join('db/migrate/*_rename_prospects_to_clients.rb')]).not_to be_empty
      end

      it 'creates a rename attribute migration file' do
        migrate
        expect(Dir[root.join('db/migrate/*_rename_first_name_to_surname_in_clients.rb')]).not_to be_empty # rubocop:disable Layout/LineLength
      end

      it 'creates a model file' do
        migrate
        expect(File).to exist root.join('app/models/client.rb')
      end

      it 'creates a controller file' do
        migrate
        expect(File).to exist root.join('app/controllers/clients_controller.rb')
      end

      it 'creates a rspec model file' do
        migrate
        expect(File).to exist root.join('spec/models/client_spec.rb')
      end

      it 'creates a rspec feature file' do
        migrate
        expect(File).to exist root.join('spec/features/client_spec.rb')
      end

      it 'undefines a model class' do
        migrate
        expect { Prospect }.to raise_error(NameError)
      end

      it 'defines a model class' do
        migrate
        expect { Client }.not_to raise_error
      end

      it 'does not respond to old model attribute' do
        migrate
        expect(Client.new).not_to respond_to(:first_name)
      end

      it 'responds to new model attribute' do
        migrate
        expect(Client.new).to respond_to(:surname)
      end
    end
  end
end
