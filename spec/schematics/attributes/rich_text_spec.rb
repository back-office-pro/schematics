require 'schematics/attributes/rich_text'

describe Schematics::Attributes::RichText do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) do
    Schematics::Entities::Entity.create(
      name: 'entity',
      descriptor: 'type',
      attributes: [{ name: 'type', type: 'string' }]
    )
  end
  let(:name) { 'summary' }
  let(:options) { {} }

  it { is_expected.not_to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }

  its(:type) { is_expected.to eq('rich_text') }
  its(:column_name) { is_expected.to eq('summary') }
  its(:preload) { is_expected.to eq(:rich_text_summary) }
  its(:icon) { is_expected.to eq(:align_justify) }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      #{name}&.to_plain_text&.searchize
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_rich_text :summary
    RUBY
  end
end
