# frozen_string_literal: true

describe Schematics::Commands::RenameEntity do
  subject(:command) { described_class.new(entity:, attribute:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'prospect') }
  let(:attribute) { 'client' }

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
  end
end
