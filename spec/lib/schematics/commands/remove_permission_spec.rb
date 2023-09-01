# frozen_string_literal: true

describe Schematics::Commands::RemovePermission do
  subject(:command) { described_class.new(entity:, attribute:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { 'create' }

  its(:to_s) { is_expected.to eq('Remove the create permission of Client') }
  its(:weight) { is_expected.to eq(4) }

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(PermissionGenerator) }
    its(:size) { is_expected.to eq(1) }
  end
end
