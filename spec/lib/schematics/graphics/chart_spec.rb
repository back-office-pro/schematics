# frozen_string_literal: true

describe Schematics::Graphics::Chart do
  subject(:chart) { described_class.new(entity, type, x_axis, y_axis) }

  let(:entity) do
    Schematics::Entities::Entity.build(
      name: 'user',
      attributes: [
        {
          name: 'locale',
          type: 'enum'
        }
      ]
    )
  end
  let(:type) { 'pie' }
  let(:x_axis) { Schematics::Graphics::Axes::X.build(entity, agregate: 'group', field: 'locale') }
  let(:y_axis) { Schematics::Graphics::Axes::Y.build(entity, agregate: 'count') }

  its(:type) { is_expected.to eq(:pie_chart) }
  its(:icon) { is_expected.to eq(:chart_pie) }
  its(:class_name) { is_expected.to eq('User') }
  its(:border_width) { is_expected.to be_zero }
  its(:joins) { is_expected.to be_empty }
end
