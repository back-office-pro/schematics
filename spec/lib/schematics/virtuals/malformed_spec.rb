# frozen_string_literal: true

describe Schematics::Virtuals::Malformed do
  subject(:virtual) { described_class.build(entity, name:, function:, options:) }

  let(:entity) do
    Schematics::Entities::Entity.build(
      name: 'product',
      descriptor: 'full_name',
      attributes: [
        { name: 'price', type: 'float' }
      ]
    )
  end
  let(:name) { 'has_stock' }
  let(:function) { '$in_stock = true' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }

  its(:open_api_type) { is_expected.to eq(String) }
  its(:function) { is_expected.to eq('raise ArgumentError') }
  its(:to_sql) { is_expected.to eq("products.in_stock = 'true'") }
  its(:preload) { is_expected.to be_empty }
  its(:icon) { is_expected.to eq(:exclamation_triangle) }
  its(:weight) { is_expected.to eq(1) }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      define_attribute_method :has_stock
      def has_stock
        raise ArgumentError
      rescue StandardError => e
        e.exception(Virtuals::Errors.const_get(e.class.to_s).new(e))
      end
    RUBY
  end
end
