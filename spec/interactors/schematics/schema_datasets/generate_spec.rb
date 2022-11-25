# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::SchemaDatasets::Generate do
  let(:schema_dataset) { SchemaDataset.create!(data:, state: :in_progress) }
  let(:current_schema) { Schematics::Schema.new(data: current_data) }
  let(:admin_role) { Role.create!(name: 'Admin') }

  before do
    admin_role
    Tenant.instance_variable_set(:@current_schema, current_schema)
  end

  after(:all) { Git.init.clean(ff: true, d: true) } # rubocop:disable RSpec/BeforeAfterAll

  describe '.call' do
    subject(:call) { described_class.call(schema_dataset:) }

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

      it { is_expected.to be_a_success }

      it 'creates a migration file' do
        expect(Dir['db/migrate/*_create_prospects.rb']).not_to be_empty
      end

      it 'creates a slug migration file' do
        expect(Dir['db/migrate/*_add_slug_to_prospects.rb']).not_to be_empty
      end

      it 'creates a lock_version migration file' do
        expect(Dir['db/migrate/*_add_lock_version_to_prospects.rb']).not_to be_empty
      end

      it 'creates a counter cache migration file' do
        expect(Dir['db/migrate/*_add_comments_count_to_prospects.rb']).not_to be_empty
      end

      it 'creates a model file' do
        expect(File).to exist('app/models/prospect.rb')
      end

      it 'creates a controller file' do
        expect(File).to exist('app/controllers/prospects_controller.rb')
      end

      it 'creates a rspec model file' do
        expect(File).to exist('spec/models/prospect_spec.rb')
      end

      it 'creates a serializer file' do
        expect(File).to exist('app/serializers/prospect_serializer.rb')
      end

      it 'creates a rspec feature file' do
        expect(File).to exist('spec/features/prospect_spec.rb')
      end
    end

    context 'when renaming an entity' do
      let(:current_data) do
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
      let(:data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'buyer',
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
        expect(File).not_to exist('app/models/prospect.rb')
      end

      it 'destroys the controller file' do
        expect(File).not_to exist('app/controllers/prospects_controller.rb')
      end

      it 'destroys the rspec model file' do
        expect(File).not_to exist('spec/models/prospect_spec.rb')
      end

      it 'destroys the serializer file' do
        expect(File).not_to exist('app/serializers/prospect_serializer.rb')
      end

      it 'destroys the rspec feature file' do
        expect(File).not_to exist('spec/features/prospect_spec.rb')
      end

      it 'creates a migration file' do
        expect(Dir['db/migrate/*_rename_prospects_to_buyers.rb']).not_to be_empty
      end

      it 'creates a model file' do
        expect(File).to exist('app/models/buyer.rb')
      end

      it 'creates a controller file' do
        expect(File).to exist('app/controllers/buyers_controller.rb')
      end

      it 'creates a rspec model file' do
        expect(File).to exist('spec/models/buyer_spec.rb')
      end

      it 'creates a serializer file' do
        expect(File).to exist('app/serializers/buyer_serializer.rb')
      end

      it 'creates a rspec feature file' do
        expect(File).to exist('spec/features/buyer_spec.rb')
      end
    end

    context 'when destroying an entity' do
      let(:data) { [] }
      let(:current_data) do
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
        expect(Dir['db/migrate/*_drop_prospects.rb']).not_to be_empty
      end

      it 'destroys the model file' do
        expect(File).not_to exist('app/models/prospect.rb')
      end

      it 'destroys the controller file' do
        expect(File).not_to exist('app/controllers/prospects_controller.rb')
      end

      it 'destroys the rspec model file' do
        expect(File).not_to exist('spec/models/prospect_spec.rb')
      end

      it 'destroys the serializer file' do
        expect(File).not_to exist('app/serializers/prospect_serializer.rb')
      end

      it 'destroys the rspec feature file' do
        expect(File).not_to exist('spec/features/prospect_spec.rb')
      end
    end

    context 'when adding a new attribute' do
      let(:current_data) do
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

      it { is_expected.to be_a_success }

      it 'creates a migration file' do
        expect(Dir['db/migrate/*_add_last_name_to_clients.rb']).not_to be_empty
      end
    end

    context 'when removing an attribute' do
      let(:current_data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'client',
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

      it 'creates a migration file' do
        expect(Dir['db/migrate/*_remove_last_name_from_clients.rb']).not_to be_empty
      end
    end

    context 'when renaming an attribute' do
      let(:current_data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'client',
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
            name: 'client',
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
        expect(Dir['db/migrate/*_rename_last_name_to_surname_in_clients.rb']).not_to be_empty
      end
    end
  end
end
