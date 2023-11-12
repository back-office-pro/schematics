# frozen_string_literal: true

describe Schematics::Commands::AddPermission do
  subject(:command) { described_class.new(entity:, attribute:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { 'create' }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Add a permission create to client') }
  its(:weight) { is_expected.to eq(4) }

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(PermissionGenerator) }
    its(:size) { is_expected.to eq(1) }
  end
end
