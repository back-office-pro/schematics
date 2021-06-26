# frozen_string_literal: true

require 'schematics/graphics/axes/x'
require 'schematics/entities/entity'

describe Schematics::Graphics::Axes::X do
  subject(:axis) { described_class.new(entity, agregate, field) }

  let(:entity) { Schematics::Entities::Entity.create(name: 'product') }
  let(:field) { nil }
  let(:agregate) { 'sum' }

  its(:to_sql) { is_expected.to eq(:all) }
  its(:icon) { is_expected.to eq(:caret_square_right) }
  its(:class_name) { is_expected.to eq('Product') }
end
