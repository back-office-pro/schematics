# frozen_string_literal: true

describe Schematics::Commands::RenamePermission do
  subject(:command) { described_class.new(entity:, attribute:, target:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { 'create' }
  let(:target) { 'show' }

  its(:to_spec) { is_expected.to eq('Rename the permission create of client to show') }
  its(:weight) { is_expected.to eq(4) }

  describe '#generators' do
    subject { command.generators }

    its([0]) { is_expected.to be_a(PermissionGenerator) }
    its(:size) { is_expected.to eq(1) }
  end
end
