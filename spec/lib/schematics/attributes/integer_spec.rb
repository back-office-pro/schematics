# frozen_string_literal: true

describe Schematics::Attributes::Integer do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'entity') }
  let(:name) { 'price' }
  let(:options) do
    {
      unit: '$'
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }
  it { is_expected.to be_a(Schematics::Behaviours::Numerable) }

  its(:database_type) { is_expected.to eq('integer') }
  its(:default) { is_expected.to eq(1) }
  its(:column_name) { is_expected.to eq('price') }
  its(:open_api_type) { is_expected.to eq(Integer) }
  its(:unit) { is_expected.to eq('$') }
  its(:precision) { is_expected.to be_zero }
  its(:validators) { is_expected.to eq(numericality: { allow_blank: true, only_integer: true }) }
  its(:icon) { is_expected.to eq(:arrow_up_1_9) } # rubocop:disable Naming/VariableNumber

  its(:available_options) do # rubocop:disable RSpec/ExampleLength
    is_expected.to include(
      Schematics::Options::GreaterThan,
      Schematics::Options::GreaterThanOrEqualTo,
      Schematics::Options::EqualTo,
      Schematics::Options::LessThan,
      Schematics::Options::LessThanOrEqualTo,
      Schematics::Options::OtherThan,
      Schematics::Options::Unit,
      Schematics::Options::Default
    )
  end

  context 'when there is a default value' do
    let(:options) { { default: 10 } }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        attribute :price, default: -> { 10 }
      RUBY
    end
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 100 }

    it { is_expected.to eq('$100') }
  end
end
