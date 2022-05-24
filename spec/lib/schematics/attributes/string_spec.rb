# frozen_string_literal: true

describe Schematics::Attributes::String do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'last_name' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('last_name') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:icon) { is_expected.to eq(:align_justify) }
  its(:default) { is_expected.to be_a(String) }
  its(:validators) { is_expected.to be_empty }
  its('validators.to_str') { is_expected.to be_blank }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.last_name') }
  its(:to_s) { is_expected.to eq('schema:user_last_name') }
  its(:available_options) { is_expected.to include(:unique, :encrypted, :min, :limit, :length) }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      last_name: last_name&.to_s
    RUBY
  end

  context 'when string is unique' do
    let(:options) { { unique: true } }

    it { is_expected.to be_unique }
    its(:validators) { is_expected.to eq(uniqueness: { case_sensitive: true, allow_blank: true }) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :last_name, {:uniqueness=>{:case_sensitive=>true, :allow_blank=>true}}
      RUBY
    end
  end

  context 'when string is required' do
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
