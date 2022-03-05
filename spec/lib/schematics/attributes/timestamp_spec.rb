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

  its(:type) { is_expected.to eq('datetime') }
  its(:column_name) { is_expected.to eq('read_at') }
  its(:open_api_type) { is_expected.to eq('string') }
  its(:icon) { is_expected.to eq(:calendar_alt) }
  its(:validators) { is_expected.to be_empty }
  its(:validate) { is_expected.to be_nil }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('messages.read_at') }
  its(:to_s) { is_expected.to eq('schema:message_read_at') }

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { Time.parse('01/01/2021 10:00 +0000').in_time_zone }

    it { is_expected.to eq('Friday 01 January 2021 10:00') }
  end
end
