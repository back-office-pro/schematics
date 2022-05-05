# frozen_string_literal: true

describe Schematics::Commands::RenameAttribute do
  subject(:command) { described_class.new(entity, attribute, target) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'client') }
  let(:attribute) { 'first_name' }
  let(:target) { 'name' }

  its(:execute) do
    is_expected.to eq <<~SHELL
      rails generate migration rename_first_name_to_name_in_clients
    SHELL
  end
end
