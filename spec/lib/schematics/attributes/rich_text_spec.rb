# frozen_string_literal: true

describe Schematics::Attributes::RichText do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.create(name: 'entity') }
  let(:name) { 'summary' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
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
      summary&.to_plain_text&.parameterize(separator: ' ')
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_rich_text :summary
    RUBY
  end
end
