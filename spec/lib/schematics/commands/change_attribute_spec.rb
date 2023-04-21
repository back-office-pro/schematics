# frozen_string_literal: true

describe Schematics::Commands::ChangeAttribute do
  subject(:command) { described_class.new(entity:, attribute:, target:) }

  include_context 'with custom generated attribute'

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { 'first_name' }
  let(:target) { 'string' }

  its(:weight) { is_expected.to eq(3) }

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
    its(:size) { is_expected.to eq(1) }
  end
end
