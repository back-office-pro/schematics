# frozen_string_literal: true

require 'schematics/attributes/text'
require 'schematics/entities/entity'

describe Schematics::Attributes::Text do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.create(name: 'entity') }
  let(:name) { 'content' }
  let(:options) do
    {
      limit: 100,
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Editable) }

  its(:type) { is_expected.to eq('text') }
  its(:column_name) { is_expected.to eq('content') }
  its(:icon) { is_expected.to eq(:align_justify) }
  its(:input_type) { is_expected.to eq(:textarea) }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      content&.parameterize(separator: ' ')
    RUBY
  end
end
