# frozen_string_literal: true

describe Schematics::Attributes::UserAgent do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'session') }
  let(:name) { 'user_agent' }
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
  its(:column_name) { is_expected.to eq('user_agent') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:input_name) { is_expected.to eq('session[user_agent]') }
  its(:icon) { is_expected.to eq(:computer) }

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Chrome/100' }

    it { is_expected.to eq('Chrome 100 macOS') }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::String,
        Schematics::Attributes::Text,
        Schematics::Attributes::Action,
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
        Schematics::Attributes::Url
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
