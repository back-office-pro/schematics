# frozen_string_literal: true

describe Schematics::Attributes::ModelField do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'stat') }
  let(:name) { 'attribute' }
  let(:options) { {} }

  before do
    allow(Schematics::Schema.instance).to receive(:entities).and_return([entity])
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
  its(:column_name) { is_expected.to eq('attribute') }
  its(:open_api_type) { is_expected.to eq('string') }
  its(:icon) { is_expected.to eq(:code) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:default) { is_expected.to be_nil }
  its(:validators) { is_expected.to eq(inclusion: { in: [] }, allow_blank: true) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('stats.attribute') }
  its(:to_s) { is_expected.to eq('schema:stat_attribute') }

  its(:validate) do
    is_expected.to eq <<~RUBY
      validates :attribute, {:inclusion=>{:in=>[]}, :allow_blank=>true}
    RUBY
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 'Stat#attribute' }

    it { is_expected.to eq('Stat#attribute') }
  end
end
