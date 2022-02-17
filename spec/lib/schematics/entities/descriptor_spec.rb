# frozen_string_literal: true

describe Schematics::Entities::Descriptor do
  subject(:descriptor) { described_class.build(entity, 'type') }

  let(:entity) do
    Schematics::Entities::Entity.build(
      name: 'entity',
      descriptor: 'type',
      attributes: [
        { name: 'type', type: 'string' }
      ]
    )
  end

  its(:serializer_class) { is_expected.to be_a(Class) }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      def to_s
        type_formatted || id
      end
    RUBY
  end
end
