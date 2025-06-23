# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Commands::AddPermission do
  subject(:command) { described_class.new(entity:, attribute:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'client') }
  let(:attribute) { 'create' }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Add a permission **create** to **client**') }
  its(:weight) { is_expected.to eq(3) }

  describe '#generators' do
    subject { command.generators }

    its(:size) { is_expected.to eq(1) }
    its([0]) { is_expected.to be_a(PermissionGenerator) }

    its([0]) do
      is_expected.to have_attributes(
        name: 'Default::Client',
        options: a_hash_including(action: attribute),
        behavior: :invoke
      )
    end
  end
end
