# frozen_string_literal: true

describe Schematics::Commands::AddAttribute do
  subject(:command) { described_class.new(entity:, attribute:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { 'first_name' }

  its(:execute) do
    is_expected.to eq <<~SHELL
      rails generate migration add_first_name_to_clients schema:client_first_name
    SHELL
  end
end
