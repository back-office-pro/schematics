# frozen_string_literal: true

describe Schematics::Attributes::Model do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'permission') }
  let(:name) { 'model' }
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
  its(:column_name) { is_expected.to eq('model') }
  its(:open_api_type) { is_expected.to eq('string') }
  its(:icon) { is_expected.to eq(:project_diagram) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:default) { is_expected.to eq('Permission') }
  its(:validators) { is_expected.to eq(inclusion: { in: ['Permission'] }, allow_blank: true) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('permissions.model') }
  its(:to_s) { is_expected.to eq('schema:permission_model') }

  its(:validate) do
    is_expected.to eq <<~RUBY
      validates :model, {:inclusion=>{:in=>["Permission"]}, :allow_blank=>true}
    RUBY
  end
end
