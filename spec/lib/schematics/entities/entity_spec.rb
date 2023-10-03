# frozen_string_literal: true

describe Schematics::Entities::Entity do
  subject(:entity) { described_class.new(schema:, name:, attributes:, options:) }

  let(:schema) { Schematics::Schema.new }
  let(:name) { 'discussion' }
  let(:options) { { core: true, existing: true } }
  let(:attributes) do
    [
      {
        name: 'content',
        type: 'rich_text'
      },
      {
        name: 'record',
        type: 'belongs_to',
        options: {
          polymorphic: true
        }
      }
    ]
  end

  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_core }
  it { is_expected.to be_existing }
  it { is_expected.to be_multisearchable }
  it { is_expected.to be_valid }

  its(:icon) { is_expected.to eq(:square_caret_right) }
  its(:class_name) { is_expected.to eq('Discussion') }
  its(:multisearch_query) { is_expected.to eq(:rich_text_content_body_i_cont) }
  its(:model_class) { is_expected.to be_nil }
  its(:weight) { is_expected.to eq(0) }
  its(:joins) { is_expected.to be_empty }
  its(:to_str) { is_expected.to be_blank }
  its(:includes) { is_expected.to eq([{ rich_text_content: [embeds_attachments: :blob] }]) }
  its(:preload) { is_expected.to eq([{ record: :string_translations }]) }

  its(:available_options) do # rubocop:disable RSpec/ExampleLength
    is_expected.to contain_exactly(
      Schematics::Options::Core,
      Schematics::Options::Hidden,
      Schematics::Options::Existing,
      Schematics::Options::Descriptor,
      Schematics::Options::Actions,
      Schematics::Options::Icon
    )
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      def search_data = {
        content: content&.to_plain_text,
        record: record&.to_s,
        created_at:
      }
    RUBY
  end

  context 'when entity name is dangerous' do
    let(:name) { 'association' }

    it { is_expected.not_to be_valid }
  end

  context 'when entity name is already taken' do
    let(:name) { 'user' }

    it { is_expected.not_to be_valid }
  end

  context 'when entity name contains whitespace characters' do
    let(:name) { '  user  ' }

    its(:name) { is_expected.to eq('user') }
  end
end
