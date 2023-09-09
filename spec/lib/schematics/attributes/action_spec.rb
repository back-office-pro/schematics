# frozen_string_literal: true

describe Schematics::Attributes::Action do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'permission') }
  let(:name) { 'action' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('action') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:input_name) { is_expected.to eq('permission[action]') }
  its(:icon) { is_expected.to eq(:hand_rock) }

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::String,
        Schematics::Attributes::Text,
        Schematics::Attributes::Address,
        Schematics::Attributes::Citext,
        Schematics::Attributes::Color,
        Schematics::Attributes::Country,
        Schematics::Attributes::Email,
        Schematics::Attributes::Ip,
        Schematics::Attributes::Locale,
        Schematics::Attributes::Mime,
        Schematics::Attributes::ModelField,
        Schematics::Attributes::Model,
        Schematics::Attributes::Phone,
        Schematics::Attributes::TimeZone,
        Schematics::Attributes::UserAgent,
        Schematics::Attributes::Url
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
