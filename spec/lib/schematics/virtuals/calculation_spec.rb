# frozen_string_literal: true

describe Schematics::Virtuals::Calculation do
  subject(:virtual) do
    described_class.create(entity, name: name, function: function, options: options)
  end

  let(:entity) do
    Schematics::Entities::Entity.create(
      name: 'product',
      descriptor: 'full_name',
      attributes: [
        { name: 'price', type: 'float' }
      ]
    )
  end
  let(:name) { 'tax_inclusive_price' }
  let(:function) { '($price ** $category.vat)' }
  let(:options) do
    {
      unit: '€',
      scale: 2
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }

  its(:function) { is_expected.to eq('(price ** category.vat)') }
  its(:to_sql) { is_expected.to eq('(products.price ^ categories.vat)') }
  its(:preload) { is_expected.to eq([:category]) }
  its(:icon) { is_expected.to eq(:square_root_alt) }
  its(:unit) { is_expected.to eq('€') }
  its(:scale) { is_expected.to eq(2) }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      def tax_inclusive_price
        (price ** category.vat)
      rescue StandardError => e
        e
      end
    RUBY
  end
end
