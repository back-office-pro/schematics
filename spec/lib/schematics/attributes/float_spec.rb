# frozen_string_literal: true

describe Schematics::Attributes::Float do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'entity') }
  let(:name) { 'weight' }
  let(:options) do
    {
      unit: 'kg'
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }
  it { is_expected.to be_a(Schematics::Behaviours::Numerable) }
  it { is_expected.to be_a(Schematics::Behaviours::Incrementable) }

  its(:database_type) { is_expected.to eq('float') }
  its(:default) { is_expected.to eq(1.5) }
  its(:column_name) { is_expected.to eq('weight') }
  its(:open_api_type) { is_expected.to eq(Float) }
  its(:input_name) { is_expected.to eq('entity[weight]') }
  its(:unit) { is_expected.to eq('kg') }
  its(:validators) { is_expected.to eq(numericality: { allow_blank: true }) }
  its(:icon) { is_expected.to eq(:arrow_up_1_9) } # rubocop:disable Naming/VariableNumber
  its(:to_spec) { is_expected.to eq('A entity has a **weight** attribute of type *float*') }

  its(:available_options) do # rubocop:disable RSpec/ExampleLength
    is_expected.to contain_exactly(
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::GreaterThan,
      Schematics::Options::GreaterThanOrEqualTo,
      Schematics::Options::EqualTo,
      Schematics::Options::LessThan,
      Schematics::Options::LessThanOrEqualTo,
      Schematics::Options::OtherThan,
      Schematics::Options::Unit,
      Schematics::Options::Precision,
      Schematics::Options::Separator,
      Schematics::Options::AutoIncrement
    )
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 100.099 }

    it { is_expected.to eq('100.099 kg') }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::Byte,
        Schematics::Attributes::Currency,
        Schematics::Attributes::Percentage,
        Schematics::Attributes::Rating
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
