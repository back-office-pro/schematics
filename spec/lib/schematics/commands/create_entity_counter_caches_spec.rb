# frozen_string_literal: true

describe Schematics::Commands::CreateEntityCounterCaches do
  subject(:command) { described_class.new(entity:) }

  let(:entity) { Schematics::Entities::Entity.new(name:, attributes:, options:) }
  let(:name) { 'assembly' }
  let(:options) { {} }
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

    context 'when entity class already exists' do
      let(:options) { { existing: true } }

      it { is_expected.to be_empty }
    end
  end
end
