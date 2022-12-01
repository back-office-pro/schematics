# frozen_string_literal: true

describe Schematics::Commands::AddAttribute do
  subject(:command) { described_class.new(entity:, attribute:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { 'first_name' }

  before do
    allow(ActiveRecord::Base)
      .to receive_message_chain(:connection, :valid_type?) # rubocop:disable RSpec/MessageChain
      .and_return(true)
  end

  its(:weight) { is_expected.to eq(3) }

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
  end
end
