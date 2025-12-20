# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Commands::RenameAttribute do
  subject(:command) { described_class.new(entity:, attribute:, target:) }

  include_context 'with custom generated attribute'

  let(:entity) { Schematics::Entities::Entity.new(name: 'client') }
  let(:attribute) { Schematics::Attributes::Attribute.build(entity:, type:, name: 'first_name') }
  let(:target) { Schematics::Attributes::Attribute.build(entity:, type:, name: 'name') }
  let(:type) { 'string' }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:weight) { is_expected.to eq(2) }

  its(:to_spec) do
    is_expected.to eq('Rename the attribute **first name** of **client** to **name**')
  end

  describe '#generators' do
    subject { command.generators }

    context 'when attribute is migratable' do
      its(:size) { is_expected.to eq(2) }
      its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its([1]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'rename_first_name_to_name_in_clients',
          behavior: :invoke
        )
      end

      its([1]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.client.name',
          options: a_hash_including(rename: 'activerecord.attributes.client.first_name'),
          behavior: :invoke
        )
      end
    end

    context 'when attribute is not migratable' do
      let(:type) { 'attachment' }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.client.name',
          options: a_hash_including(rename: 'activerecord.attributes.client.first_name'),
          behavior: :invoke
        )
      end
    end
  end
end
