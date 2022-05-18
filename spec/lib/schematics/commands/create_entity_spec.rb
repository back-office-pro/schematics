# frozen_string_literal: true

describe Schematics::Commands::CreateEntity do
  subject(:command) { described_class.new(entity:) }

  let(:entity) { Schematics::Entities::Entity.new(name:, attributes:, associations:) }
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

  its(:execute) do
    is_expected.to eq(
      [
        'rails generate scaffold assembly schema:assembly_name schema:assembly_owner --skip-resource-route', # rubocop:disable Layout/LineLength
        'rails generate rspec:feature assembly',
        'rails generate fixtures assembly',
        'rails generate locales assembly',
        'rails generate migration add_slug_to_assemblies slug:string:uniq',
        'rails generate migration add_lock_version_to_assemblies lock_version:integer',
        'rails generate migration create_join_table_assemblies_parts assemblies:join_table_first parts:join_table_second', # rubocop:disable Layout/LineLength
        'rails generate migration add_assemblies_count_to_users assemblies_count:integer',
        "rails 'schematics:permissions:create[Assembly]'"
      ]
    )
  end

  context 'when entity class is already defined' do
    let(:name) { 'object' }

    its(:execute) do
      is_expected.to eq <<~SHELL
        rails generate scaffold_controller object --skip-resource-route
      SHELL
    end
  end
end
