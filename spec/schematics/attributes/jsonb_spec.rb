# frozen_string_literal: true

require 'schematics/attributes/jsonb'
require 'schematics/entities/entity'

describe Schematics::Attributes::Jsonb do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.create(name: 'user') }
  let(:name) { 'preferences' }
  let(:options) { { default: { theme: 'light', sidebar_toggled: false } } }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }

  its(:type) { is_expected.to eq('jsonb') }
  its(:column_name) { is_expected.to eq('preferences') }
  its(:validators) { is_expected.to be_empty }
  its(:validate) { is_expected.to be_nil }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.preferences') }
  its(:to_s) { is_expected.to eq('schema:user_preferences') }
  its(:options_for_migration) { is_expected.to eq(options) }

  context 'when there is no default' do
    let(:options) { {} }

    its(:to_str) { is_expected.to be_blank }
    its(:options_for_migration) { is_expected.to be_empty }
  end
end
