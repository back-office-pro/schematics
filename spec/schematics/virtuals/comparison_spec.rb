# frozen_string_literal: true

require 'schematics/virtuals/comparison'
require 'schematics/entities/entity'

describe Schematics::Virtuals::Comparison do
  subject(:virtual) do
    described_class.create(entity, name: name, function: function, options: options)
  end

  let(:entity) do
    Schematics::Entities::Entity.create(
      name: 'product',
      descriptor: 'full_name',
      attributes: [
        { name: 'price', type: 'float' },
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

  its(:to_str) do
    is_expected.to eq <<~RUBY
      def big_price
        price >= 100 && category.vat == 10
      rescue StandardError => e
        e
      end
    RUBY
  end
end
