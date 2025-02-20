# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Attributes::Date do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'created_at' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Indexable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }

  its(:database_type) { is_expected.to eq('date') }
  its(:column_name) { is_expected.to eq('created_at') }
  its(:open_api_body_type) { is_expected.to eq('date') }
  its(:open_api_schema_type) { is_expected.to eq('date') }
  its(:open_api_query_type) { is_expected.to eq('date') }
  its(:input_name) { is_expected.to eq('user[created_at]') }
  its(:icon) { is_expected.to eq(:calendar_days) }
  its(:default) { is_expected.to be_a(String) }
  its(:validators) { is_expected.to be_empty }
  its('validators.to_str') { is_expected.to be_blank }
  its(:weight) { is_expected.to eq(1) }
  its(:group_method) { is_expected.to eq(:group_by_day) }
  its(:to_sql) { is_expected.to eq('users.created_at') }
  its(:to_s) { is_expected.to eq('created_at:date:index') }
  its(:to_spec) { is_expected.to eq('A user has a **created at** attribute of type *date*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.user.created_at') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
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
      Schematics::Options::StartDate,
      Schematics::Options::EndDate
    )
  end

  context 'when date is required' do
    let(:options) { { required: true } }

    its(:validators) { is_expected.to eq(presence: true) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :created_at, {presence: true}
      RUBY
    end
  end

  context 'when date has less_than option' do
    let(:options) { { less_than: 'start_at' } }

    its(:validators) { is_expected.to eq(comparison: { allow_blank: true, less_than: :start_at }) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :created_at, {comparison: {less_than: :start_at, allow_blank: true}}
      RUBY
    end
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { Time.parse('2021/01/01 00:00 +0000').in_time_zone }

    it { is_expected.to eq('Friday 01 January, 2021') }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::Datetime,
        Schematics::Attributes::Time
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
