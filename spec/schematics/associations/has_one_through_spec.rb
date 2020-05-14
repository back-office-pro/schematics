describe Schematics::Associations::HasOneThrough do
  subject(:association) { described_class.new(belongs_to, through) }

  let(:parent_entity) do
    Schematics::Entities::Entity.create(
      name: "category",
      descriptor: "label",
      attributes: [{ name: "label", type: "string" }]
    )
  end
  let(:entity) do
    Schematics::Entities::Entity.create(
      name: "product",
      descriptor: "reference",
      attributes: [{ name: "reference", type: "string" }]
    )
  end
  let(:through_entity) do
    Schematics::Entities::Entity.create(
      name: "sub_category",
      descriptor: "designation",
      attributes: [{ name: "designation", type: "string" }]
    )
  end
  let(:belongs_to) do
    Schematics::Attributes::Attribute.create(through_entity, name: "category", type: "belongs_to")
  end
  let(:through) do
    Schematics::Attributes::Attribute.create(entity, name: "sub_category", type: "belongs_to")
  end

  before do
    belongs_to.inverse_descriptor = parent_entity.descriptor
  end

  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }

  describe "#type" do
    subject { association.type }

    it { is_expected.to eq("has_one") }
  end

  describe "#to_str" do
    subject { association.to_str }

    it do
      is_expected.to eq <<~RUBY
        has_one :category, class_name: 'Category', foreign_key: 'category_id', through: :sub_category
      RUBY
    end
  end

  describe "#name" do
    subject { association.name }

    it { is_expected.to eq("category") }
  end

  describe "#class_name" do
    subject { association.class_name }

    it { is_expected.to eq("Category") }
  end

  describe "#descriptor" do
    subject { association.descriptor.name }

    it { is_expected.to eq("label") }
  end

  describe "#search_data" do
    subject { association.search_data }

    it do
      is_expected.to eq <<~RUBY
        category&.label&.searchize
      RUBY
    end
  end
end
