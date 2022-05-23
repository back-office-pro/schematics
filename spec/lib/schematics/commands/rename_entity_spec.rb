# frozen_string_literal: true

describe Schematics::Commands::RenameEntity do
  subject(:command) { described_class.new(entity:, attribute:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'prospect') }
  let(:attribute) { 'client' }

  its(:execute) do
    is_expected.to eq(
      [
        'rails generate migration rename_clients_to_prospects',
        'rails destroy scaffold client --skip-migration --skip-resource-route',
        'rails destroy fixtures client',
        'rails generate fixtures prospect',
        'rails destroy locales client',
        'rails generate locales prospect',
        "rails 'schematics:permissions:rename[Client,Prospect]'"
      ]
    )
  end
end
