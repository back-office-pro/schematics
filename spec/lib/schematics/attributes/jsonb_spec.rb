# frozen_string_literal: true

describe Schematics::Attributes::Jsonb do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'preferences' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }

  its(:icon) { is_expected.to eq(:table) }
  its(:database_index_type) { is_expected.to eq(:gin) }
  its(:database_type) { is_expected.to eq('jsonb') }
  its(:default) { is_expected.to be_empty }
  its(:column_name) { is_expected.to eq('preferences') }
  its(:open_api_type) { is_expected.to eq({}) }
  its(:validators) { is_expected.to be_empty }
  its('validators.to_str') { is_expected.to be_blank }
  its(:weight) { is_expected.to eq(1) }
  its(:permitted_params) { is_expected.to eq(preferences: {}) }
  its(:to_sql) { is_expected.to eq('users.preferences') }
  its(:to_s) { is_expected.to eq('schema:user_preferences') }
  its(:available_options) { is_expected.to include(Schematics::Options::Default) }

  context 'when there is a default' do
    let(:options) { { default: { theme: 'light', sidebar_toggled: false } } }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        attribute :preferences, default: -> { {"theme":"light","sidebar_toggled":false} }
      RUBY
    end
  end
end
