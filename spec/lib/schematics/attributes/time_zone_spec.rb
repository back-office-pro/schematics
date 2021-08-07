# frozen_string_literal: true

describe Schematics::Attributes::TimeZone do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.create(name: 'user') }
  let(:name) { 'time_zone' }
  let(:options) { {} }

  before do
    allow(ActiveSupport::TimeZone).to receive(:all).and_return([ActiveSupport::TimeZone['Paris']])
  end

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Editable) }
  it { is_expected.to be_a(Schematics::Behaviours::Enumerable) }

  its(:type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('time_zone') }
  its(:icon) { is_expected.to eq(:clock) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:default) { is_expected.to eq('Paris') }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.time_zone') }
  its(:to_s) { is_expected.to eq('schema:user_time_zone') }
  its(:input_collection) { is_expected.to eq([['', ''], ['Paris', '(GMT+01:00) Paris']]) }

  its(:validators) do
    is_expected.to eq(inclusion: { in: ['Paris'] }, allow_blank: true)
  end

  its(:validate) do
    is_expected.to eq <<~RUBY
      validates :time_zone, {:inclusion=>{:in=>["Paris"]}, :allow_blank=>true}
    RUBY
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      time_zone&.parameterize(separator: ' ')
    RUBY
  end

  context 'when time_zone is required' do
    let(:options) { { required: true } }

    its(:input_collection) { is_expected.to eq([['Paris', '(GMT+01:00) Paris']]) }

    its(:validators) do
      is_expected.to eq(inclusion: { in: ['Paris'] }, presence: true, allow_blank: false)
    end

    its(:validate) do
      is_expected.to eq <<~RUBY
        validates :time_zone, {:presence=>true, :inclusion=>{:in=>["Paris"]}, :allow_blank=>false}
      RUBY
    end
  end
end
