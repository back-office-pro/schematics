# frozen_string_literal: true

describe Schematics::Entities::Preloader do
  subject(:router) { described_class.new(entity) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name:, attributes:) }
  let(:name) { 'discussion' }
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

  its(:joins) { is_expected.to be_empty }

  its(:includes) do
    is_expected.to eq(
      [
        { rich_text_content: [embeds_attachments: :blob] },
        { record: :string_translations }
      ]
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      scope :with_record, -> { includes([{:record=>:string_translations}]) }
    RUBY
  end
end
