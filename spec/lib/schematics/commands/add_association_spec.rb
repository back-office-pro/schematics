# frozen_string_literal: true

describe Schematics::Commands::AddAssociation do
  subject(:command) { described_class.new(entity:, attribute:) }

  include_context 'with custom generated attribute'

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { 'user' }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:weight) { is_expected.to eq(3) }

  its(:to_spec) do
    is_expected.to eq('Add a many-to-many association between **client** and **user**')
  end

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
    its([1]) { is_expected.to be_a(TranslationGenerator) }
    its(:size) { is_expected.to eq(2) }
  end
end
