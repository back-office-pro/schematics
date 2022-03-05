# frozen_string_literal: true

describe Schematics::Attributes::Jsonb do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'user') }
  let(:name) { 'preferences' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }

  its(:type) { is_expected.to eq('jsonb') }
  its(:column_name) { is_expected.to eq('preferences') }
  its(:open_api_type) { is_expected.to eq('object') }
  its(:validators) { is_expected.to be_empty }
  its(:validate) { is_expected.to be_nil }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.preferences') }
  its(:to_s) { is_expected.to eq('schema:user_preferences') }
  its(:options_for_migration) { is_expected.to be_empty }

  context 'when there is a default' do
    let(:default) { { theme: 'light', sidebar_toggled: false } }
    let(:options) { { default: } }
    
    its(:default) { is_expected.to eq(default) }
    its(:options_for_migration) { is_expected.to eq(options) }
  end
end
