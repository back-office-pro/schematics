# frozen_string_literal: true

describe Schematics::Virtuals::Comparison do
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
  let(:name) { 'big_price' }
  let(:function) { '$price >= 100 && $category.vat == 10' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }

  its(:function) { is_expected.to eq('price >= 100 && category.vat == 10') }
  its(:to_sql) { is_expected.to eq('products.price >= 100 AND categories.vat = 10') }
  its(:preload) { is_expected.to eq([:category]) }
  its(:icon) { is_expected.to eq(:toggle_on) }
  its(:weight) { is_expected.to eq(1) }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      define_attribute_method :big_price
      def big_price
        price >= 100 && category.vat == 10
      rescue StandardError => e
        e.exception(Virtuals::Errors.const_get(e.class.to_s).new(e))
      end
    RUBY
  end

  describe '#format' do
    subject { virtual.format(value) }

    let(:value) { 'true' }

    it { is_expected.to eq('TRUE') }
  end
end
