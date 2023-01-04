# frozen_string_literal: true

describe Schematics::Attributes::Country do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'country' }
  let(:options) { {} }

  before do
    allow(ISO3166::Country).to receive(:codes).and_return(['FR'])
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
  its(:column_name) { is_expected.to eq('country') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:icon) { is_expected.to eq(:earth_europe) }
  its(:default) { is_expected.to eq('FR') }
  its(:validators) { is_expected.to eq(inclusion: { in: ['FR'] }, allow_blank: true) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.country') }
  its(:to_s) { is_expected.to eq('schema:user_country') }
  its(:collection) { is_expected.to eq([['', ''], %w[France FR]]) }

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :country, {:inclusion=>{:in=>["FR"]}, :allow_blank=>true}
    RUBY
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      country: country&.to_s
    RUBY
  end

  context 'when country is required' do
    let(:options) { { required: true } }

    its(:collection) { is_expected.to eq([%w[France FR]]) }
    its(:validators) { is_expected.to eq(inclusion: { in: ['FR'] }, presence: true) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :country, {:presence=>true, :inclusion=>{:in=>["FR"]}}
      RUBY
    end
  end
end
