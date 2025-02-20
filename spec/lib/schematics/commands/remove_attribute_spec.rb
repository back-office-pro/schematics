# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Commands::RemoveAttribute do
  subject(:command) { described_class.new(entity:, attribute:) }

  include_context 'with custom generated attribute'

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { Schematics::Attributes::Attribute.build(entity:, type:, name: 'first_name') }
  let(:type) { 'string' }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Remove the attribute **first name** of **client**') }
  its(:weight) { is_expected.to eq(2) }

  describe '#generators' do
    subject { command.generators }

    context 'when attribute is migratable' do
      its(:size) { is_expected.to eq(2) }
      its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its([1]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'remove_first_name_from_clients',
          behavior: :invoke
        )
      end

      its([1]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.client.first_name',
          behavior: :revoke
        )
      end
    end

    context 'when attribute is not migratable' do
      let(:type) { 'attachment' }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.client.first_name',
          behavior: :revoke
        )
      end
    end
  end
end
