# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Commands::RemoveAssociation do
  subject(:command) { described_class.new(entity:, attribute:) }

  include_context 'with custom generated attribute'

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'client') }
  let(:attribute) do
    Schematics::Associations::Association.build(
      type: 'has_and_belongs_to_many',
      entity:,
      name: 'users'
    )
  end

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:weight) { is_expected.to eq(2) }

  its(:to_spec) do
    is_expected.to eq('Remove the many-to-many association between **client** and **users**')
  end

  describe '#generators' do
    subject { command.generators }

    its(:size) { is_expected.to eq(2) }
    its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
    its([1]) { is_expected.to be_a(TranslationGenerator) }

    its([0]) do
      is_expected.to have_attributes(
        name: 'drop_join_table_clients_users',
        behavior: :invoke
      )
    end

    its([1]) do
      is_expected.to have_attributes(
        name: 'activerecord.attributes.client.users',
        behavior: :revoke
      )
    end
  end
end
