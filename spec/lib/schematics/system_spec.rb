# frozen_string_literal: true

describe Schematics::System do
  subject(:system) { described_class }

  let(:entity) { Schematics::Entities::Entity.build(name:, attributes:, associations:) }
  let(:name) { 'role' }
  let(:attributes) do
    [
      {
        name: 'name',
        type: 'string'
      },
      {
        name: 'owner',
        type: 'belongs_to',
        options: {
          type: 'user',
          inverse: {
            name: 'roles'
          }
        }
      }
    ]
  end
  let(:associations) do
    [
      {
        type: 'has_and_belongs_to_many',
        name: 'permission'
      }
    ]
  end

  describe '.generate' do
    subject { system.generate(entity) }

    let(:expected_command_lines) do
      [
        'rails generate scaffold role schema:role_name schema:role_owner --skip-resource-route',
        'rails generate rspec:acceptance role',
        'rails generate migration add_deleted_at_to_roles deleted_at:datetime',
        'rails generate migration add_slug_to_roles slug:string:uniq',
        'rails generate migration add_lock_version_to_roles lock_version:integer',
        'rails generate migration create_join_table_roles_permissions roles permissions:join_table_uuid', # rubocop:disable Layout/LineLength
        'rails generate migration add_roles_count_to_users roles_count:integer'
      ]
    end

    it { is_expected.to eq(expected_command_lines) }

    context 'when entity class is already defined' do
      let(:name) { 'object' }
      let(:expected_command_lines) do
        [
          'rails generate scaffold_controller object --skip-resource-route'
        ]
      end

      it { is_expected.to eq(expected_command_lines) }
    end
  end

  describe '.destroy_entity' do
    subject { system.destroy_entity(entity) }

    let(:expected_command_lines) do
      [
        'rails destroy scaffold role --skip-migration --skip-resource-route',
        'rails destroy rspec:acceptance role',
        'rails generate migration drop_roles_table schema:role_name schema:role_owner'
      ]
    end

    it { is_expected.to eq(expected_command_lines) }
  end

  describe '.destroy_entity_attribute' do
    subject { system.destroy_entity_attribute(entity, 'name') }

    let(:expected_command_lines) do
      [
        'rails generate migration remove_name_from_roles schema:role_name'
      ]
    end

    it { is_expected.to eq(expected_command_lines) }
  end
end
