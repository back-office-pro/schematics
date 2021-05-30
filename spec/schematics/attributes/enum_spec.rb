# frozen_string_literal: true

require 'schematics/attributes/enum'
require 'schematics/entities/entity'

describe Schematics::Attributes::Enum do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.create(name: 'product') }
  let(:name) { 'state' }
  let(:options) { { values: %w[available available_soon not_available] } }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Editable) }
  it { is_expected.to be_a(Schematics::Behaviours::Enumerable) }

  its(:type) { is_expected.to eq('integer') }
  its(:column_name) { is_expected.to eq('state') }
  its(:icon) { is_expected.to eq(:list_ol) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:default) { is_expected.to eq('available') }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('products.state') }
  its(:to_s) { is_expected.to eq('schema:product_state') }
  its(:search_data) { is_expected.to eq('state') }
  its(:options_for_migration) { is_expected.to be_empty }

  its(:validators) do
    is_expected.to eq(
      {
        inclusion: {
          in: %w[available available_soon not_available],
        },
        allow_nil: true,
      }
    )
  end

  its(:input_collection) do
    is_expected.to eq(
      [
        %w[available Available],
        ['available_soon', 'Available soon'],
        ['not_available', 'Not available'],
      ]
    )
  end

  its(:validate) do
    is_expected.to eq <<~RUBY
      validates :state, {:inclusion=>{:in=>["available", "available_soon", "not_available"]}, :allow_nil=>true}
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      enum state: {:available=>0, :available_soon=>1, :not_available=>2}, _prefix: true
    RUBY
  end

  context 'when there is a default' do
    let(:options) do
      {
        default: 'available',
        values: %w[available available_soon not_available],
      }
    end

    its(:options_for_migration) { is_expected.to be_empty }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        enum state: {:available=>0, :available_soon=>1, :not_available=>2}, _prefix: true, _default: "available"
      RUBY
    end
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 'available' }

    it { is_expected.to eq('Available') }
  end
end
