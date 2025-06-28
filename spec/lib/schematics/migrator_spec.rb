# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Migrator do
  subject(:migration) { described_class.new(database, new_schema, current_schema) }

  let(:database) { 'primary' }
  let(:new_schema) { Schematics::Schema.new(data: new_data) }
  let(:current_schema) { Schematics::Schema.new(data: current_data) }

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

    describe '#build_commands' do
      subject { migration.build_commands }

      its([0]) { is_expected.to be_a(Schematics::Commands::CreateEntity) }
      its([0]) { is_expected.to have_attributes(entity: kind_of(Schematics::Entities::Entity)) }
      its(:size) { is_expected.to eq(1) }
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to be_empty }
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

    describe '#build_commands' do
      subject { migration.build_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::RenameEntity) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Entities::Entity)
        )
      end
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to eq(['prospect']) }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to be_empty }
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

    describe '#build_commands' do
      subject { migration.build_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::AddAttribute) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Attributes::String)
        )
      end
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
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

    describe '#build_commands' do
      subject { migration.build_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::RenameAttribute) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Attributes::String),
          target: kind_of(Schematics::Attributes::String)
        )
      end
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
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
              type: 'text'
            },
            {
              id: 'd46f9336-d17e-4840-bd90-c36c8b44ca6d',
              name: 'last_name',
              type: 'text'
            }
          ]
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      its(:size) { is_expected.to eq(2) }
      its([0]) { is_expected.to be_a(Schematics::Commands::ChangeAttribute) }
      its([1]) { is_expected.to be_a(Schematics::Commands::ChangeAttribute) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Attributes::Text),
          target: kind_of(Schematics::Attributes::String)
        )
      end

      its([1]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Attributes::Text),
          target: kind_of(Schematics::Attributes::String)
        )
      end
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to be_empty }
    end
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

    describe '#build_commands' do
      subject { migration.build_commands }

      its(:size) { is_expected.to eq(2) }
      its([0]) { is_expected.to be_a(Schematics::Commands::RenameEntity) }
      its([1]) { is_expected.to be_a(Schematics::Commands::RenameAttribute) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Entities::Entity)
        )
      end

      its([1]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Attributes::String),
          target: kind_of(Schematics::Attributes::String)
        )
      end
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to eq(['prospect']) }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to be_empty }
    end
  end

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

    describe '#build_commands' do
      subject { migration.build_commands }

      it { is_expected.to be_empty }
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      its([0]) { is_expected.to be_a(Schematics::Commands::DestroyEntity) }
      its([0]) { is_expected.to have_attributes(entity: kind_of(Schematics::Entities::Entity)) }
      its(:size) { is_expected.to eq(1) }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to be_empty }
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

    describe '#build_commands' do
      subject { migration.build_commands }

      it { is_expected.to be_empty }
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::RemoveAttribute) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Attributes::String)
        )
      end
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
  end

  context 'when adding a new action' do
    let(:current_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          options: {
            actions: ['show']
          }
        }
      ]
    end
    let(:new_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          options: {
            actions: %w[show create]
          }
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::AddPermission) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: :create
        )
      end
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to be_empty }
    end
  end

  context 'when removing an action' do
    let(:current_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          options: {
            actions: %w[show create]
          }
        }
      ]
    end
    let(:new_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          options: {
            actions: ['show']
          }
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      it { is_expected.to be_empty }
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::RemovePermission) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: :create
        )
      end
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to be_empty }
    end
  end

  context 'when adding a new event' do
    let(:current_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          attributes: [
            {
              id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
              name: 'state',
              type: 'state_machine',
              options: {
                values: %w[
                  pending
                  closed
                  refused
                ]
              }
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
              name: 'state',
              type: 'state_machine',
              options: {
                values: %w[
                  pending
                  closed
                  refused
                ],
                events: [
                  {
                    id: '3cdbd211-8786-4ef0-a3a6-15b29b117654',
                    name: 'close',
                    from: 'pending',
                    to: 'closed'
                  }
                ]
              }
            }
          ]
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      its(:size) { is_expected.to eq(2) }
      its([0]) { is_expected.to be_a(Schematics::Commands::AddPermission) }
      its([1]) { is_expected.to be_a(Schematics::Commands::AddTranslation) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: 'close'
        )
      end

      its([1]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Options::StateMachineEvent)
        )
      end
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
  end

  context 'when removing an event' do
    let(:current_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          attributes: [
            {
              id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
              name: 'state',
              type: 'state_machine',
              options: {
                values: %w[
                  pending
                  closed
                  refused
                ],
                events: [
                  {
                    id: '3cdbd211-8786-4ef0-a3a6-15b29b117654',
                    name: 'close',
                    from: 'pending',
                    to: 'closed'
                  }
                ]
              }
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
              name: 'state',
              type: 'state_machine',
              options: {
                values: %w[
                  pending
                  closed
                  refused
                ]
              }
            }
          ]
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      it { is_expected.to be_empty }
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      its(:size) { is_expected.to eq(2) }
      its([0]) { is_expected.to be_a(Schematics::Commands::RemovePermission) }
      its([1]) { is_expected.to be_a(Schematics::Commands::RemoveTranslation) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: 'close'
        )
      end

      its([1]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Options::StateMachineEvent)
        )
      end
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
  end

  context 'when renaming an event' do
    let(:current_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          attributes: [
            {
              id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
              name: 'state',
              type: 'state_machine',
              options: {
                values: %w[
                  pending
                  closed
                  refused
                ],
                events: [
                  {
                    id: '3cdbd211-8786-4ef0-a3a6-15b29b117654',
                    name: 'close',
                    from: 'pending',
                    to: 'closed'
                  }
                ]
              }
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
              name: 'state',
              type: 'state_machine',
              options: {
                values: %w[
                  pending
                  closed
                  refused
                ],
                events: [
                  {
                    id: '3cdbd211-8786-4ef0-a3a6-15b29b117654',
                    name: 'cancel',
                    from: 'pending',
                    to: 'closed'
                  }
                ]
              }
            }
          ]
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      its(:size) { is_expected.to eq(2) }
      its([0]) { is_expected.to be_a(Schematics::Commands::RenamePermission) }
      its([1]) { is_expected.to be_a(Schematics::Commands::RenameTranslation) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: 'close',
          target: 'cancel'
        )
      end

      its([1]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Options::StateMachineEvent),
          target: kind_of(Schematics::Options::StateMachineEvent)
        )
      end
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
  end

  context 'when adding a new enum value' do
    let(:current_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          attributes: [
            {
              id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
              name: 'state',
              type: 'enum',
              options: {
                values: %w[
                  pending
                  closed
                ]
              }
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
              name: 'state',
              type: 'enum',
              options: {
                values: %w[
                  pending
                  closed
                  refused
                ]
              }
            }
          ]
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::AddTranslation) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Options::EnumValue)
        )
      end
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
  end

  context 'when removing an enum value' do
    let(:current_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          attributes: [
            {
              id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
              name: 'state',
              type: 'enum',
              options: {
                values: %w[
                  pending
                  closed
                  refused
                ]
              }
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
              name: 'state',
              type: 'enum',
              options: {
                values: %w[
                  pending
                  closed
                ]
              }
            }
          ]
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      it { is_expected.to be_empty }
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::RemoveTranslation) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Options::EnumValue)
        )
      end
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
  end

  context 'when renaming an enum value' do
    let(:current_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          attributes: [
            {
              id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
              name: 'state',
              type: 'enum',
              options: {
                values: %w[
                  pending
                ]
              }
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
              name: 'state',
              type: 'enum',
              options: {
                values: %w[
                  closed
                ]
              }
            }
          ]
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::AddTranslation) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Options::EnumValue)
        )
      end
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::RemoveTranslation) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Options::EnumValue)
        )
      end
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
  end

  context 'when adding a new virtual' do
    let(:current_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client'
        }
      ]
    end
    let(:new_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          virtuals: [
            {
              id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
              name: 'full_name',
              function: '$last_name $first_name'
            }
          ]
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::AddTranslation) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Virtuals::Concatenation)
        )
      end
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
  end

  context 'when removing a virtual' do
    let(:current_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          virtuals: [
            {
              id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
              name: 'full_name',
              function: '$last_name $first_name'
            }
          ]
        }
      ]
    end
    let(:new_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client'
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      it { is_expected.to be_empty }
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::RemoveTranslation) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Virtuals::Concatenation)
        )
      end
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
  end

  context 'when renaming a virtual' do
    let(:current_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          virtuals: [
            {
              id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
              name: 'full_name',
              function: '$last_name $first_name'
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
          virtuals: [
            {
              id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
              name: 'full_client_name',
              function: '$last_name $first_name'
            }
          ]
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::RenameTranslation) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Virtuals::Concatenation),
          target: kind_of(Schematics::Virtuals::Concatenation)
        )
      end
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
  end

  context 'when adding a new association' do
    let(:current_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client'
        }
      ]
    end
    let(:new_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          associations: [
            {
              name: 'users',
              type: 'has_and_belongs_to_many'
            }
          ]
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::AddAssociation) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Associations::HasAndBelongsToMany)
        )
      end
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
  end

  context 'when removing an association' do
    let(:current_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client',
          associations: [
            {
              name: 'users',
              type: 'has_and_belongs_to_many'
            }
          ]
        }
      ]
    end
    let(:new_data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'client'
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      it { is_expected.to be_empty }
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::RemoveAssociation) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Associations::HasAndBelongsToMany)
        )
      end
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
  end

  context 'when changing attribute uniqueness' do
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
              type: 'string',
              options: {
                unique: true
              }
            }
          ]
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Schematics::Commands::ChangeAttributeUniqueness) }

      its([0]) do
        is_expected.to have_attributes(
          entity: kind_of(Schematics::Entities::Entity),
          attribute: kind_of(Schematics::Attributes::String)
        )
      end
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
  end

  context 'when changing attribute mandatoriness' do
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
              type: 'string',
              options: {
                required: true
              }
            }
          ]
        }
      ]
    end

    describe '#build_commands' do
      subject { migration.build_commands }

      it { is_expected.to be_empty }
    end

    describe '#clean_commands' do
      subject { migration.clean_commands }

      it { is_expected.to be_empty }
    end

    describe '#new_entities' do
      subject { migration.new_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#old_entities' do
      subject { migration.old_entities.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#changed_entities' do
      subject { migration.changed_entities.map(&:name) }

      it { is_expected.to eq(['client']) }
    end
  end
end
