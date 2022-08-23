# frozen_string_literal: true

describe Schematics::Commands::CreateEntityCounterCaches do
  subject(:command) { described_class.new(entity:) }

  let(:entity) { Schematics::Entities::Entity.new(name:, attributes:) }
  let(:name) { 'assembly' }
  let(:attributes) do
    [
      {
        name: 'name',
        type: 'string'
      },
      {
        name: 'owner',
        type: 'belongs_to',
        options: {
          type: 'user',
          inverse: {
            name: 'assemblies'
          }
        }
      }
    ]
  end

  its(:weight) { is_expected.to eq(2) }

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }

    context 'when entity class is already defined' do
      let(:name) { 'object' }

      it { is_expected.to be_empty }
    end
  end
end
