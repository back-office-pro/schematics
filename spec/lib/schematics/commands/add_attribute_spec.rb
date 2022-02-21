# frozen_string_literal: true

describe Schematics::Commands::AddAttribute do
  subject(:command) { described_class.new(entity, attribute) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'client') }
  let(:attribute) { 'first_name' }

  describe '#execute' do
    subject { command.execute }

    let(:expected_command_line) do
      <<~SHELL
        rails generate migration add_first_name_to_clients schema:client_first_name
      SHELL
    end

    it { is_expected.to eq(expected_command_line) }
  end
end
