# frozen_string_literal: true

describe Schematics::Attributes::UserAgent do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'session') }
  let(:name) { 'user_agent' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('user_agent') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:icon) { is_expected.to eq(:computer) }

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Chrome/100' }

    it { is_expected.to eq('Chrome 100 macOS') }
  end
end
