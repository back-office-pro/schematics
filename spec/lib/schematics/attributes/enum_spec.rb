# frozen_string_literal: true

describe Schematics::Attributes::Enum do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'product') }
  let(:name) { 'state' }
  let(:options) { { values: %w[available available_soon not_available] } }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Enumerable) }

  its(:database_type) { is_expected.to eq('integer') }
  its(:column_name) { is_expected.to eq('state') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:icon) { is_expected.to eq(:list_ol) }
  its(:default) { is_expected.to eq('available') }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('products.state') }
  its(:to_s) { is_expected.to eq('schema:product_state') }
  its(:search_data) { is_expected.to eq('state:') }
  its(:options_for_migration) { is_expected.to be_empty }

  its(:validators) do
    is_expected.to eq(
      {
        inclusion: {
          in: %w[available available_soon not_available]
        },
        allow_blank: true
      }
    )
  end

  its(:collection) do
    is_expected.to eq(
      [
        ['', ''],
        %w[Available available],
        ['Available soon', 'available_soon'],
        ['Not available', 'not_available']
      ]
    )
  end

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :state, {:inclusion=>{:in=>["available", "available_soon", "not_available"]}, :allow_blank=>true}
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      enum :state, {:available=>0, :available_soon=>1, :not_available=>2}, prefix: true
    RUBY
  end

  context 'when required' do
    let(:options) do
      {
        required: true,
        values: %w[available available_soon not_available]
      }
    end

    its(:collection) do
      is_expected.to eq(
        [
          %w[Available available],
          ['Available soon', 'available_soon'],
          ['Not available', 'not_available']
        ]
      )
    end

    its(:validators) do
      is_expected.to eq(
        inclusion: { in: %w[available available_soon not_available] },
        presence: true
      )
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :state, {:presence=>true, :inclusion=>{:in=>["available", "available_soon", "not_available"]}}
      RUBY
    end
  end

  context 'when there is a default' do
    let(:options) do
      {
        default: 'available',
        values: %w[available available_soon not_available]
      }
    end

    its(:options_for_migration) { is_expected.to be_empty }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        enum :state, {:available=>0, :available_soon=>1, :not_available=>2}, prefix: true, default: "available"
      RUBY
    end
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 'available' }

    it { is_expected.to eq('Available') }
  end
end
