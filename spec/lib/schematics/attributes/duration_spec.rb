# frozen_string_literal: true

describe Schematics::Attributes::Duration do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'movie') }
  let(:name) { 'duration' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
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
  it { is_expected.to be_a(Schematics::Behaviours::Unincrementable) }
  it { is_expected.not_to be_auto_increment }

  its(:database_type) { is_expected.to eq('integer') }
  its(:column_name) { is_expected.to eq('duration') }
  its(:open_api_type) { is_expected.to eq(Integer) }
  its(:input_name) { is_expected.to eq('movie[duration]') }
  its(:icon) { is_expected.to eq(:hourglass) }
  its(:to_spec) { is_expected.to eq('A movie has a **duration** attribute of type *duration*') }

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
      Schematics::Options::Unit
    )
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 100 }

    it { is_expected.to eq('1 minute and 40 seconds') }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::Integer,
        Schematics::Attributes::ResponseCode
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
