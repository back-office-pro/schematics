# frozen_string_literal: true

describe Schematics::Commands::AddAttribute do
  subject(:command) { described_class.new(entity:, attribute:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { 'first_name' }

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
  end
end
