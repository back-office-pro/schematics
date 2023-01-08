# frozen_string_literal: true

describe Schematics::Attributes::ModelField do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'assembly') }
  let(:schema) { Schematics::Schema.new }
  let(:name) { 'part' }
  let(:options) { { type: 'numerable' } }

  before do
    allow(schema).to receive(:entities).and_return([entity])
  end

  it { is_expected.to be_a(Schematics::Behaviours::Identifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Enumerable) }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('part') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:icon) { is_expected.to eq(:code) }
  its(:default) { is_expected.to be_nil }
  its(:validators) { is_expected.to eq(inclusion: { in: [] }, allow_blank: true) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('assemblies.part') }
  its(:to_s) { is_expected.to eq('schema:assembly_part') }

  its(:available_options) do
    is_expected.to include(
      Schematics::Options::DependsOn,
      Schematics::Options::Type
    )
  end

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :part, {:inclusion=>{:in=>[]}, :allow_blank=>true}
    RUBY
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 'Assembly#part' }

    it { is_expected.to eq('Assembly#part') }
  end
end
