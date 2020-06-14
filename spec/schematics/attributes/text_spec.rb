describe Schematics::Attributes::Text do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) do
    Schematics::Entities::Entity.create(
      name: "entity",
      descriptor: "type",
      attributes: [{ name: "type", type: "string" }]
    )
  end
  let(:name) { "text" }
  let(:options) do
    {
      limit: 100,
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Editable) }

  its(:migration_options) { is_expected.to eq([:unique, :required, :default, :limit]) }
  its(:api_param_type) { is_expected.to eq("string") }
  its(:icon) { is_expected.to eq(:align_justify) }
  its(:input_type) { is_expected.to eq(:textarea) }
  its(:search_data) do
    is_expected.to eq <<~RUBY
      #{name}&.searchize
    RUBY
  end
end
