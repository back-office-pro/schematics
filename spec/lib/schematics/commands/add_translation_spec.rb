# frozen_string_literal: true

describe Schematics::Commands::AddTranslation do
  subject(:command) { described_class.new(entity:, attribute:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { 'attributes.client.name' }

  its(:weight) { is_expected.to eq(4) }

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(TranslationGenerator) }
  end
end
