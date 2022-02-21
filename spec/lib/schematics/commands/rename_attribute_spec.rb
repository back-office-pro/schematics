# frozen_string_literal: true

describe Schematics::Commands::RenameAttribute do
  subject(:command) { described_class.new(entity, attribute, target) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'client') }
  let(:attribute) { 'first_name' }
  let(:target) { 'name' }

  describe '#execute' do
    subject { command.execute }

    let(:expected_command_line) do
      <<~SHELL
        rails generate migration rename_first_name_to_name_in_clients
      SHELL
    end

    it { is_expected.to eq(expected_command_line) }
  end
end
