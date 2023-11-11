# frozen_string_literal: true

describe Schematics::Commands::ChangeAttributeUniqueness do
  subject(:command) { described_class.new(entity:, attribute:) }

  include_context 'with custom generated attribute'

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { Schematics::Attributes::Attribute.build(entity:, type:, name: 'first_name') }
  let(:type) { 'string' }

  its(:to_s) { is_expected.to eq('Change first_name attribute uniqueness of Client') }
  its(:weight) { is_expected.to eq(3) }

  describe '#generators' do
    subject { command.generators }

    context 'when attribute is migratable' do
      its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its(:size) { is_expected.to eq(1) }
    end

    context 'when attribute is not migratable' do
      let(:type) { 'attachment' }

      it { is_expected.to be_empty }
    end
  end
end
