# frozen_string_literal: true

describe Schematics::Attributes::Time do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'message') }
  let(:name) { 'hour' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }

  its(:type) { is_expected.to eq('time') }
  its(:column_name) { is_expected.to eq('hour') }
  its(:open_api_type) { is_expected.to eq(DateTime) }
  its(:icon) { is_expected.to eq(:clock) }
  its(:validators) { is_expected.to be_empty }
  its('validators.to_str') { is_expected.to be_blank }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('messages.hour') }
  its(:to_s) { is_expected.to eq('schema:message_hour') }

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { Time.parse('01/01/2021 10:00 +0000').in_time_zone }

    it { is_expected.to eq('10:00') }
  end
end
