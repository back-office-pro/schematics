# frozen_string_literal: true

describe Schematics::Commands::CreateEntityPolymorphicCounterCaches do
  subject(:command) { described_class.new(entity:) }

  before { stub_const('ActiveStorage::Attachment', Class.new) }

  let(:entity) { Schematics::Entities::Entity.new(name:) }
  let(:name) { 'category' }

  its(:weight) { is_expected.to eq(2) }

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }

    context 'when entity class is already defined' do
      let(:name) { 'ActiveStorage::Attachment' }

      it { is_expected.to be_empty }
    end
  end
end
