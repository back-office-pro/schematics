# frozen_string_literal: true

describe Schematics::Attributes::Date do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'user') }
  let(:name) { 'created_at' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Editable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }

  its(:type) { is_expected.to eq('date') }
  its(:column_name) { is_expected.to eq('created_at') }
  its(:open_api_type) { is_expected.to eq(Date) }
  its(:icon) { is_expected.to eq(:calendar_days) }
  its(:default) { is_expected.to be_nil }
  its(:validators) { is_expected.to eq(date: { allow_blank: true }) }
  its(:weight) { is_expected.to eq(1) }
  its(:group_method) { is_expected.to eq(:group_by_day) }
  its(:to_sql) { is_expected.to eq('users.created_at') }
  its(:to_s) { is_expected.to eq('schema:user_created_at') }

  its(:validate) do
    is_expected.to eq <<~RUBY
      validates :created_at, {:date=>{:allow_blank=>true}}
    RUBY
  end

  context 'when date is required' do
    let(:options) { { required: true } }

    its(:validators) { is_expected.to eq(presence: true, date: { allow_blank: false }) }

    its(:validate) do
      is_expected.to eq <<~RUBY
        validates :created_at, {:presence=>true, :date=>{:allow_blank=>false}}
      RUBY
    end
  end

  context 'when date has before option' do
    let(:options) { { before: 'start_at' } }

    its(:validators) { is_expected.to eq(date: { allow_blank: true, before: :start_at }) }

    its(:validate) do
      is_expected.to eq <<~RUBY
        validates :created_at, {:date=>{:allow_blank=>true, :before=>:start_at}}
      RUBY
    end
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { Time.parse('01/01/2021 00:00 +0000').in_time_zone }

    it { is_expected.to eq('Friday 01 January, 2021') }
  end
end
