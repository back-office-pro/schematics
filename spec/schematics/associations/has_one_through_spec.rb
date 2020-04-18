describe Schematics::Associations::HasOneThrough do
  subject(:association) { described_class.new(belongs_to, through) }

  let(:parent_entity) do
    Schematics::Entity.create(
      type: "category",
      descriptor: "label",
      attributes: [{ name: "label", type: "string" }]
    )
  end
  let(:entity) do
    Schematics::Entity.create(
      type: "product",
      descriptor: "reference",
      attributes: [{ name: "reference", type: "string" }]
    )
  end
  let(:through_entity) do
    Schematics::Entity.create(
      type: "sub_category",
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
  it { is_expected.to be_a(Schematics::Behaviours::Filterable) }
  it { is_expected.to be_a(Schematics::Behaviours::Sortable) }
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

  describe "#filter_scope" do
    subject { association.filter_scope }

    it do
      is_expected.to eq <<~RUBY
        scope :by_category, -> category { joins(:sub_category).where(category: category) }
      RUBY
    end
  end

  describe "#sort_scope" do
    subject { association.sort_scope }

    it do
      is_expected.to eq <<~RUBY
        scope :sort_by_category, -> sort_direction do
          joins(:sub_category, :category).
          merge(Category.order(label: sort_direction))
        end
      RUBY
    end
  end
end
