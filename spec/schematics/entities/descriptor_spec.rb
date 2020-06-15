describe Schematics::Entities::Descriptor do
  subject(:descriptor) { described_class.create(entity, 'type') }

  let(:entity) do
    Schematics::Entities::Entity.create(
      name: 'entity',
      descriptor: 'type',
      attributes: [
        { name: 'type', type: 'string' },
      ],
    )
  end

  its(:to_s) { is_expected.to eq('type') }
  its(:serializer_class) { is_expected.to be_a(Class) }
  its(:to_str) do
    is_expected.to eq <<~RUBY
      extend FriendlyId
      friendly_id :type
      alias_attribute :to_s, :type
    RUBY
  end
end
