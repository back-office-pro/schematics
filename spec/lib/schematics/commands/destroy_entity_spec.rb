# frozen_string_literal: true

describe Schematics::Commands::DestroyEntity do
  subject(:command) { described_class.new(entity) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'client', attributes:) }
  let(:attributes) do
    [
      {
        name: 'first_name',
        type: 'string'
      }
    ]
  end

  its(:execute) do
    is_expected.to eq(
      [
        'rails destroy scaffold client --skip-migration --skip-resource-route',
        'rails destroy rspec:feature client',
        'rails destroy fixtures client',
        'rails destroy locales client',
        'rails generate migration drop_clients schema:client_first_name',
        "rails 'schematics:permissions:destroy[Client]'"
      ]
    )
  end
end
