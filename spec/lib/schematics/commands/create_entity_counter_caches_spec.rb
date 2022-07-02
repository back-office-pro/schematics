# frozen_string_literal: true

describe Schematics::Commands::CreateEntityCounterCaches do
  subject(:command) { described_class.new(entity:) }

  let(:entity) { Schematics::Entities::Entity.new(name:, attributes:) }
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

  its(:execute) do
    is_expected.to eq(
      [
        'rails generate migration add_assemblies_count_to_users assemblies_count:integer'
      ]
    )
  end

  context 'when entity class is already defined' do
    let(:name) { 'object' }

    its(:execute) { is_expected.to be_empty }
  end
end
