# frozen_string_literal: true

describe Schematics::Attributes::Text do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'entity') }
  let(:name) { 'content' }
  let(:options) do
    {
      limit: 100
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Encryptable) }

  its(:database_type) { is_expected.to eq('text') }
  its(:column_name) { is_expected.to eq('content') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:icon) { is_expected.to eq(:font) }
  its(:default) { is_expected.to be_a(String) }
  its(:available_options) { is_expected.to include(Schematics::Options::Default) }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      content: content&.to_s
    RUBY
  end

  context 'when hidden' do
    let(:options) { { hidden: true } }

    it { is_expected.to be_hidden }
  end

  context 'when readonly' do
    let(:options) { { readonly: true } }

    it { is_expected.to be_readonly }
  end

  context 'when there is a default value' do
    let(:options) { { default: 'text' } }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        attribute :content, default: -> { "text" }
      RUBY
    end
  end
end
