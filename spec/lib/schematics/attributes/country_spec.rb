# frozen_string_literal: true

require 'schematics/attributes/country'
require 'schematics/entities/entity'

describe Schematics::Attributes::Country do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.create(name: 'user') }
  let(:name) { 'country' }
  let(:options) { {} }

  before do
    allow(ISO3166::Country).to receive(:codes).and_return(['FR'])
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
  its(:column_name) { is_expected.to eq('country') }
  its(:icon) { is_expected.to eq(:globe_europe) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:default) { is_expected.to eq('FR') }
  its(:validators) { is_expected.to eq({ inclusion: { in: ['FR'] }, allow_blank: true }) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.country') }
  its(:to_s) { is_expected.to eq('schema:user_country') }
  its(:input_collection) { is_expected.to eq([['', ''], %w[FR France]]) }

  its(:validate) do
    is_expected.to eq <<~RUBY
      validates :country, {:inclusion=>{:in=>["FR"]}, :allow_blank=>true}
    RUBY
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      country&.parameterize(separator: ' ')
    RUBY
  end

  context 'when country is required' do
    let(:options) { { required: true } }

    its(:input_collection) { is_expected.to eq([%w[FR France]]) }

    its(:validators) do
      is_expected.to eq({ inclusion: { in: ['FR'] }, presence: true, allow_blank: false })
    end

    its(:validate) do
      is_expected.to eq <<~RUBY
        validates :country, {:presence=>true, :inclusion=>{:in=>["FR"]}, :allow_blank=>false}
      RUBY
    end
  end
end
