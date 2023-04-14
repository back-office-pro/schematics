# frozen_string_literal: true

describe Schematics::Entities::Preloader do
  subject(:router) { described_class.new(entity) }

  let(:entity) { Schematics::Entities::Entity.new(name:, attributes:) }
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

  its(:joins) { is_expected.to eq([{ rich_text_content: [embeds_attachments: :blob] }]) }

  its(:includes) do
    is_expected.to eq(
      [
        { rich_text_content: [embeds_attachments: :blob] },
        :record
      ]
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      scope :with_content, -> { preload([{:rich_text_content=>[{:embeds_attachments=>:blob}]}]) }
      scope :with_record, -> { preload([:record]) }
    RUBY
  end
end
