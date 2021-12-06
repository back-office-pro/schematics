# frozen_string_literal: true

describe Schematics::Entities::Entity do
  subject(:entity) do
    described_class.build(name: name, attributes: attributes)
  end

  let(:name) { 'entity' }
  let(:attributes) do
    [
      {
        name: 'name',
        type: 'string'
      }
    ]
  end

  its(:icon) { is_expected.to eq(:caret_square_right) }
  its(:class_name) { is_expected.to eq('Entity') }
  its(:weight) { is_expected.to eq(0) }
  its(:viewer) { is_expected.to eq(:table) }
  its(:to_str) { is_expected.to be_blank }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      def search_data
        {
          created_at: created_at,
          name: name&.to_s
        }
      end
    RUBY
  end
end
