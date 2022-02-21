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

  describe '#execute' do
    subject { command.execute }

    let(:expected_command_lines) do
      [
        'rails destroy scaffold client --skip-migration --skip-resource-route',
        'rails destroy fixtures client',
        'rails generate migration drop_clients schema:client_first_name',
        "rails 'schematics:permissions:destroy[Client]'"
      ]
    end

    it { is_expected.to eq(expected_command_lines) }
  end
end
