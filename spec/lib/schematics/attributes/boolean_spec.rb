# frozen_string_literal: true

describe Schematics::Attributes::Boolean do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'entity') }
  let(:name) { 'toggle' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:database_type) { is_expected.to eq('boolean') }
  its(:default) { is_expected.to be_falsy }
  its(:column_name) { is_expected.to eq('toggle') }
  its(:open_api_type) { is_expected.to eq('boolean') }
  its(:icon) { is_expected.to eq(:toggle_on) }
  its(:available_options) { is_expected.to include(Schematics::Options::Default) }
  its(:search_column) { is_expected.to eq(:toggle) }
  its(:search_predicate) { is_expected.to eq(:eq) }
  its(:search_query) { is_expected.to eq(:toggle_eq) }

  context 'when there is a default value' do
    let(:options) { { default: true } }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        attribute :toggle, default: -> { true }
      RUBY
    end
  end
end
