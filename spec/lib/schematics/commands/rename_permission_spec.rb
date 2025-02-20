# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Commands::RenamePermission do
  subject(:command) { described_class.new(entity:, attribute:, target:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { 'create' }
  let(:target) { 'show' }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Rename the permission **create** of **client** to **show**') }
  its(:weight) { is_expected.to eq(3) }

  describe '#generators' do
    subject { command.generators }

    its(:size) { is_expected.to eq(1) }
    its([0]) { is_expected.to be_a(PermissionGenerator) }

    its([0]) do
      is_expected.to have_attributes(
        name: 'Client',
        options: a_hash_including(action: target, rename: attribute),
        behavior: :invoke
      )
    end
  end
end
