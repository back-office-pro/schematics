require 'schematics/attributes/string'
require 'schematics/entities/entity'

describe Schematics::Attributes::Country do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) do
    Schematics::Entities::Entity.create(
      name: 'user',
      descriptor: 'first_name',
      attributes: [{ name: 'first_name', type: 'string' }]
    )
  end
  let(:name) { 'country' }
  let(:options) { {} }

  before do
    allow(ISO3166::Country).to receive(:codes).and_return(['FR'])
  end

  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Editable) }

  its(:type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('country') }
  its(:icon) { is_expected.to eq(:globe_europe) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:default) { is_expected.to eq('FR') }
  its(:validators) { is_expected.to eq({ inclusion: { in: ['FR'] } }) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.country') }
  its(:to_s) { is_expected.to eq('schema:user_country') }
  its(:input_collection) { is_expected.to eq([%w[FR France]]) }

  its(:validate) do
    is_expected.to eq <<~RUBY
      validates :country, {:inclusion=>{:in=>["FR"]}}
    RUBY
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      country&.searchize
    RUBY
  end
end
