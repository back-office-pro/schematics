# frozen_string_literal: true

describe Schematics::Graphics::Stat do
  subject(:stat) { described_class.new(entity, agregate, field) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'product') }
  let(:field) { Schematics::Attributes::Attribute.build(entity, name: 'price', type: 'float') }
  let(:agregate) { 'sum' }

  its(:to_sql) { is_expected.to eq('products.price') }
  its(:icon) { is_expected.to eq(:caret_square_right) }
  its(:class_name) { is_expected.to eq('Product') }
end
