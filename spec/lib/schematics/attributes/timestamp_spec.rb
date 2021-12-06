# frozen_string_literal: true

describe Schematics::Attributes::Timestamp do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'message') }
  let(:name) { 'read_at' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }

  its(:type) { is_expected.to eq('timestamp') }
  its(:column_name) { is_expected.to eq('read_at') }
  its(:icon) { is_expected.to eq(:calendar_alt) }
  its(:validators) { is_expected.to be_empty }
  its(:validate) { is_expected.to be_nil }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('messages.read_at') }
  its(:to_s) { is_expected.to eq('schema:message_read_at') }

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { DateTime.parse('01/01/2021 10:00') }

    around do |example|
      I18n.with_locale(:en, &example)
    end

    it { is_expected.to eq('Friday 01 January 2021 10:00') }
  end
end
