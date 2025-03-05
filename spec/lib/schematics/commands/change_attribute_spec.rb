# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Commands::ChangeAttribute do
  subject(:command) { described_class.new(database:, entity:, attribute:, target:) }

  include_context 'with custom generated attribute'

  let(:database) { 'primary' }
  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { Schematics::Attributes::Attribute.build(entity:, type:, name: 'first_name') }
  let(:target) { Schematics::Attributes::String.new(entity:, name: 'first_name') }
  let(:type) { 'text' }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Change **first name** attribute type of **client**') }
  its(:weight) { is_expected.to eq(2) }

  describe '#generators' do
    subject { command.generators }

    context 'when attribute is migratable' do
      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'change_first_name_column_string_in_clients',
          behavior: :invoke
        )
      end
    end

    context 'when attribute is not migratable' do
      let(:type) { 'attachment' }

      it { is_expected.to be_empty }
    end
  end
end
