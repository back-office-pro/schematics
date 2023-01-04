# frozen_string_literal: true

describe Schematics::Entities::Entity do
  subject(:entity) { described_class.new(name:, attributes:, options:) }

  let(:name) { 'entity' }
  let(:options) { { core: true, existing: true } }
  let(:attributes) do
    [
      {
        name: 'name',
        type: 'string'
      }
    ]
  end

  it { is_expected.to be_a(Schematics::Behaviours::Identifiable) }
  it { is_expected.to be_core }
  it { is_expected.to be_existing }

  its(:icon) { is_expected.to eq(:square_caret_right) }
  its(:class_name) { is_expected.to eq('Entity') }
  its(:model_class) { is_expected.to be_nil }
  its(:weight) { is_expected.to eq(0) }
  its(:viewer) { is_expected.to eq(:table) }
  its(:to_str) { is_expected.to be_blank }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      def search_data = {
        name: name&.to_s,
        created_at:
      }
    RUBY
  end
end
