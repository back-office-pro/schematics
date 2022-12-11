# frozen_string_literal: true

describe Schematics::Virtuals::Comparison do
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
  let(:name) { 'big_price' }
  let(:function) { '($category.vat == 10) && ($created_at == NULL || NOW() < $created_at)' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }

  its(:open_api_type) { is_expected.to eq('boolean') }
  its(:preload) { is_expected.to eq([:category]) }
  its(:icon) { is_expected.to eq(:toggle_on) }
  its(:weight) { is_expected.to eq(1) }

  its(:to_sql) do
    is_expected.to eq <<~SQL.squish
      (categories.vat = 10) AND (products.created_at IS NULL OR NOW() < products.created_at)
    SQL
  end

  its(:search_alias) do
    is_expected.to eq <<~RUBY
      ransacker :big_price do
        Arel.sql("products.price >= 100 AND categories.vat = 10")
      end
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      define_attribute_method :big_price
      def big_price
        (self.category.vat == 10) && (self.created_at == nil || Time.current < self.created_at)
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
