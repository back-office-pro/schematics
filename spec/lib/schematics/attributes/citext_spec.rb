# frozen_string_literal: true

describe Schematics::Attributes::Citext do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'last_name' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.not_to be_case_sensitive }

  its(:database_type) { is_expected.to eq('citext') }
  its(:column_name) { is_expected.to eq('last_name') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:icon) { is_expected.to eq(:align_justify) }
  its(:default) { is_expected.to be_a(String) }
  its(:validators) { is_expected.to be_empty }
  its('validators.to_str') { is_expected.to be_blank }
  its(:search_column) { is_expected.to eq(:last_name) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:last_name_i_cont) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.last_name') }
  its(:to_s) { is_expected.to eq('schema:user_last_name') }

  context 'when attribute is unique' do
    let(:options) { { unique: true } }

    it { is_expected.to be_unique }
    its(:validators) { is_expected.to eq(uniqueness: { case_sensitive: false, allow_blank: true }) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :last_name, {:uniqueness=>{:case_sensitive=>false, :allow_blank=>true}}
      RUBY
    end
  end

  context 'when attribute is required' do
    let(:options) { { required: true } }

    it { is_expected.to be_required }
    its(:validators) { is_expected.to eq(presence: true) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :last_name, {:presence=>true}
      RUBY
    end
  end
end
