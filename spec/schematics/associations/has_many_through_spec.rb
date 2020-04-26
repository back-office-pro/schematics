describe Schematics::Associations::HasManyThrough do
  subject(:association) { described_class.new(through, belongs_to.create_inverse_association) }

  let(:parent_entity) do
    Schematics::Entity.create(
      type: "category",
      descriptor: "label",
      attributes: [{ name: "label", type: "string" }]
    )
  end
  let(:through_entity) do
    Schematics::Entity.create(
      type: "sub_category",
      descriptor: "designation",
      attributes: [{ name: "designation", type: "string" }]
    )
  end
  let(:entity) do
    Schematics::Entity.create(
      type: "product",
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

  describe "#type" do
    subject { association.type }

    it { is_expected.to eq("has_many") }
  end

  describe "#to_str" do
    subject { association.to_str }

    it do
      is_expected.to eq <<~RUBY
        has_many :products, class_name: 'Product', foreign_key: 'sub_category_id', through: :sub_categories
      RUBY
    end
  end

  describe "#name" do
    subject { association.name }

    it { is_expected.to eq("products") }
  end

  describe "#class_name" do
    subject { association.class_name }

    it { is_expected.to eq("Product") }
  end

  describe "#descriptor" do
    subject { association.descriptor.name }

    it { is_expected.to eq("reference") }
  end
end
