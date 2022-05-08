# frozen_string_literal: true

describe Schematics::Commands::ChangeAttribute do
  subject(:command) { described_class.new(entity:, attribute:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { 'first_name' }

  its(:execute) do
    is_expected.to eq <<~SHELL
      rails generate migration change_first_name_in_clients schema:client_first_name
    SHELL
  end
end
