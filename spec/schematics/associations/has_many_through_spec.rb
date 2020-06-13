describe Schematics::Associations::HasManyThrough do
  subject(:association) { described_class.new(through, belongs_to.create_inverse_association) }

  let(:parent_entity) do
    Schematics::Entities::Entity.create(
      name: "category",
      descriptor: "label",
      attributes: [{ name: "label", type: "string" }]
    )
  end
  let(:through_entity) do
    Schematics::Entities::Entity.create(
      name: "sub_category",
      descriptor: "designation",
      attributes: [{ name: "designation", type: "string" }]
    )
  end
  let(:entity) do
    Schematics::Entities::Entity.create(
      name: "product",
      descriptor: "reference",
      attributes: [{ name: "reference", type: "string" }]
    )
  end
  let(:options) do
    {
      "inverse": {
        "type": "has_many",
      },
    }
  end
  let(:belongs_to) do
    Schematics::Attributes::Attribute.create(
      through_entity,
      name: "category",
      type: "belongs_to",
      options: options
    )
  end
  let(:through) do
    Schematics::Attributes::Attribute.create(
      entity,
      name: "sub_category",
      type: "belongs_to",
      options: options
    )
  end

  before do
    belongs_to.inverse_descriptor = parent_entity.descriptor
    through.inverse_descriptor = through_entity.descriptor
  end

  its(:type) { is_expected.to eq("has_many") }
  its(:name) { is_expected.to eq("products") }
  its(:class_name) { is_expected.to eq("Product") }
  its("descriptor.name") { is_expected.to eq("reference") }
  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_many :products, class_name: 'Product', foreign_key: 'sub_category_id', through: :sub_categories
    RUBY
  end
end
