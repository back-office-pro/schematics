# frozen_string_literal: true

describe Schematics::Commands::RenameEntity do
  subject(:command) { described_class.new(entity, attribute) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'prospect') }
  let(:attribute) { 'client' }

  describe '#execute' do
    subject { command.execute }

    let(:expected_command_lines) do
      [
        'rails generate migration rename_clients_to_prospects',
        'rails destroy scaffold client --skip-migration --skip-resource-route',
        'rails destroy fixtures client',
        'rails generate fixtures prospect',
        "rails 'schematics:permissions:rename[Client,Prospect]'"
      ]
    end

    it { is_expected.to eq(expected_command_lines) }
  end
end
