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

  its(:type) { is_expected.to eq("has_one") }
  its(:name) { is_expected.to eq("category") }
  its(:class_name) { is_expected.to eq("Category") }
  its("descriptor.name") { is_expected.to eq("label") }
  its(:search_data) do
    is_expected.to eq <<~RUBY
      category&.label&.searchize
    RUBY
  end
  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_one :category, class_name: 'Category', foreign_key: 'category_id', through: :sub_category
    RUBY
  end
end
