# frozen_string_literal: true

describe Schematics::System do
  subject(:system) { described_class }

  let(:entity) { Schematics::Entities::Entity.build(name:, attributes:, associations:) }
  let(:name) { 'assembly' }
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
            name: 'assemblies'
          }
        }
      }
    ]
  end
  let(:associations) do
    [
      {
        type: 'has_and_belongs_to_many',
        name: 'part'
      }
    ]
  end

  describe '.generate' do
    subject { system.generate(entity) }

    let(:expected_command_lines) do
      [
        'rails generate scaffold assembly schema:assembly_name schema:assembly_owner --skip-resource-route', # rubocop:disable Layout/LineLength
        'rails generate migration add_slug_to_assemblies slug:string:uniq',
        'rails generate migration add_lock_version_to_assemblies lock_version:integer',
        'rails generate migration create_join_table_assemblies_parts assemblies:join_table_first parts:join_table_second', # rubocop:disable Layout/LineLength
        'rails generate migration add_assemblies_count_to_users assemblies_count:integer'
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
        'rails destroy scaffold assembly --skip-migration --skip-resource-route',
        'rails generate migration drop_assemblies_table schema:assembly_name schema:assembly_owner'
      ]
    end

    it { is_expected.to eq(expected_command_lines) }
  end

  describe '.destroy_entity_attribute' do
    subject { system.destroy_entity_attribute(entity, 'name') }

    let(:expected_command_lines) do
      [
        'rails generate migration remove_name_from_assemblies schema:assembly_name'
      ]
    end

    it { is_expected.to eq(expected_command_lines) }
  end
end
