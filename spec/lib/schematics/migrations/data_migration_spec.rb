# frozen_string_literal: true

describe Schematics::Migrations::DataMigration do
  subject(:migration) { described_class.new(new_schema, current_schema) }

  let(:new_schema) { Schematics::Schema.load(new_data) }
  let(:current_schema) { Schematics::Schema.instance.load(current_data) }

  describe '#build_commands' do
    subject { migration.build_commands }

    context 'when creating a new entity' do
      let(:current_data) { [] }
      let(:new_data) do
        [
          {
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

      its([0]) { is_expected.to be_a(Schematics::Commands::CreateEntity) }
      its([1]) { is_expected.to be_a(Schematics::Commands::CreateEntityCounterCaches) }
      its([2]) { is_expected.to be_a(Schematics::Commands::CreateEntityPolymorphicCounterCaches) }
      its(:size) { is_expected.to eq(3) }
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
      let(:new_data) do
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

      its([0]) { is_expected.to be_a(Schematics::Commands::RenameEntity) }
      its(:size) { is_expected.to eq(1) }
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
      let(:new_data) do
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

      its([0]) { is_expected.to be_a(Schematics::Commands::AddAttribute) }
      its(:size) { is_expected.to eq(1) }
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
      let(:new_data) do
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

      its([0]) { is_expected.to be_a(Schematics::Commands::RenameAttribute) }
      its(:size) { is_expected.to eq(1) }
    end

    context 'when changing attribute type' do
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
      let(:new_data) do
        [
          {
            id: '3cceed80-55c1-445f-a47b-44705c702c3d',
            name: 'client',
            attributes: [
              {
                id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
                name: 'first_name',
                type: 'citext'
              },
              {
                id: 'd46f9336-d17e-4840-bd90-c36c8b44ca6d',
                name: 'last_name',
                type: 'citext'
              }
            ]
          }
        ]
      end

      its([0]) { is_expected.to be_a(Schematics::Commands::ChangeAttribute) }
      its([1]) { is_expected.to be_a(Schematics::Commands::ChangeAttribute) }
      its(:size) { is_expected.to eq(2) }
    end

    context 'with a more complex scenario' do
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
      let(:new_data) do
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
                name: 'surname',
                type: 'string'
              }
            ]
          }
        ]
      end

      its([0]) { is_expected.to be_a(Schematics::Commands::RenameEntity) }
      its([1]) { is_expected.to be_a(Schematics::Commands::RenameAttribute) }
      its(:size) { is_expected.to eq(2) }
    end
  end

  describe '#clean_commands' do
    subject { migration.clean_commands }

    context 'when removing an entity' do
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
      let(:new_data) { [] }

      its([0]) { is_expected.to be_a(Schematics::Commands::DestroyEntity) }
      its(:size) { is_expected.to eq(1) }
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
      let(:new_data) do
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

      its([0]) { is_expected.to be_a(Schematics::Commands::RenameEntity) }
      its(:size) { is_expected.to eq(1) }
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
      let(:new_data) do
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

      its([0]) { is_expected.to be_a(Schematics::Commands::RemoveAttribute) }
      its(:size) { is_expected.to eq(1) }
    end
  end
end
