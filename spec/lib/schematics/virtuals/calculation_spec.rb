# frozen_string_literal: true

describe Schematics::Virtuals::Calculation do
  subject(:virtual) { described_class.new(entity:, name:, function:, options:) }

  let(:entity) do
    Schematics::Entities::Entity.new(
      name: 'product',
      options: {
        descriptor: 'full_name'
      },
      attributes: [
        { name: 'price', type: 'float' }
      ]
    )
  end
  let(:name) { 'tax_inclusive_price' }
  let(:function) { '($price ** $category.vat)' }
  let(:options) do
    {
      unit: '$',
      precision: 2
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }
  it { is_expected.to be_a(Schematics::Behaviours::Numerable) }

  its(:open_api_type) { is_expected.to eq(Float) }
  its(:to_sql) { is_expected.to eq('(products.price ^ categories.vat)') }
  its(:preload) { is_expected.to eq([:category]) }
  its(:icon) { is_expected.to eq(:square_root_alt) }
  its(:unit) { is_expected.to eq('$') }
  its(:precision) { is_expected.to eq(2) }
  its(:weight) { is_expected.to eq(1) }
  its(:available_options) { is_expected.to eq(%i[unit precision]) }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      define_attribute_method :tax_inclusive_price
      def tax_inclusive_price
        (self.price ** self.category.vat)
      rescue StandardError => e
        e.exception(Virtuals::Errors.const_get(e.class.to_s).new(e))
      end
    RUBY
  end

  describe '#format' do
    subject { virtual.format(value) }

    let(:value) { 100.099 }

    it { is_expected.to eq('$100.10') }
  end
end
