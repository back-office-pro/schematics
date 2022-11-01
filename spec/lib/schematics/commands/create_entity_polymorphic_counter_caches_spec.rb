# frozen_string_literal: true

describe Schematics::Commands::CreateEntityPolymorphicCounterCaches do
  subject(:command) { described_class.new(entity:) }

  let(:entity) { Schematics::Entities::Entity.new(schema:, name:, options:) }
  let(:schema) { Schematics::Schema.instance }
  let(:name) { 'category' }
  let(:options) { {} }

  its(:weight) { is_expected.to eq(2) }

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }

    context 'when entity class already exists' do
      let(:options) { { existing: true } }

      it { is_expected.to be_empty }
    end
  end
end
