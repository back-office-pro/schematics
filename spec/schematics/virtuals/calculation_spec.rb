require 'schematics/virtuals/calculation'

describe Schematics::Virtuals::Calculation do
  subject(:virtual) { described_class.new(entity, name, tokens, options) }

  let(:entity) do
    Schematics::Entities::Entity.create(
      name: 'product',
      descriptor: 'full_name',
      attributes: [
        { name: 'price', type: 'float' },
      ]
    )
  end
  let(:name) { 'tax_inclusive_price' }
  let(:options) do
    {
      unit: '€',
      scale: 2,
    }
  end
  let(:tokens) do
    Schematics::Tokens::Tokenizer.tokenize('($price + $category.vat)', 'products')
  end

  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }

  its(:function) { is_expected.to eq('(price + category.vat)') }
  its(:to_sql) { is_expected.to eq('(products.price + categories.vat)') }
  its(:preload) { is_expected.to eq([:category]) }
  its(:icon) { is_expected.to eq(:square_root_alt) }
  its(:unit) { is_expected.to eq('€') }
  its(:scale) { is_expected.to eq(2) }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      default_scope { includes([:category]) }

      def tax_inclusive_price
        (price + category.vat)
      rescue NameError => e
        Virtuals::Errors::NameError.new(e.message, e.name)
      rescue TypeError => e
        Virtuals::Errors::TypeError.new(e.message)
      end
    RUBY
  end
end
