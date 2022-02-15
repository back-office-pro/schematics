# frozen_string_literal: true

describe Schematics::Attributes::Url do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'user') }
  let(:name) { 'url' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Editable) }

  its(:type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('url') }
  its(:open_api_type) { is_expected.to eq('string') }
  its(:icon) { is_expected.to eq(:chrome) }
  its(:input_type) { is_expected.to eq(:input) }
  its(:default) { is_expected.to be_nil }
  its(:validators) { is_expected.to eq(url: { allow_blank: true }) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.url') }
  its(:to_s) { is_expected.to eq('schema:user_url') }

  its(:validate) do
    is_expected.to eq <<~RUBY
      validates :url, {:url=>{:allow_blank=>true}}
    RUBY
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      url&.to_s
    RUBY
  end

  context 'when url is unique' do
    let(:options) { { unique: true } }

    it { is_expected.to be_unique }

    its(:validators) do
      is_expected.to eq(
        uniqueness: { case_sensitive: false, allow_blank: true },
        url: { allow_blank: true }
      )
    end

    its(:validate) do
      is_expected.to eq <<~RUBY
        validates :url, {:uniqueness=>{:case_sensitive=>false, :allow_blank=>true}, :url=>{:allow_blank=>true}}
      RUBY
    end
  end

  context 'when url is required' do
    let(:options) { { required: true } }

    it { is_expected.to be_required }
    its(:default) { is_expected.to match(/www\.\w+\.com/) }
    its(:validators) { is_expected.to eq(presence: true, url: { allow_blank: false }) }

    its(:validate) do
      is_expected.to eq <<~RUBY
        validates :url, {:presence=>true, :url=>{:allow_blank=>false}}
      RUBY
    end
  end
end
