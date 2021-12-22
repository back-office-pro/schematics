# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message do
  fixtures :messages
  fixtures 'action_text/rich_texts'

  subject(:message) { messages(:one) }

  it { is_expected.to be_valid }
  it { is_expected.to have_implicit_order_column(:created_at) }

  describe '#id' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
  end

  describe '#subject' do
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to have_db_column(:subject).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_index(:subject) }
  end

  describe '#content' do
    it { is_expected.to have_rich_text(:content) }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe '#author' do
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to have_db_column(:author_id).of_type(:uuid).with_options(null: false) }

    it do
      expect(message)
        .to belong_to(:author)
        .class_name('User')
        .with_foreign_key('author_id')
        .inverse_of(:sent_messages)
        .counter_cache(:sent_messages_count)
    end
  end

  describe '#recipient' do
    it { is_expected.to validate_presence_of(:recipient) }
    it { is_expected.to have_db_column(:recipient_id).of_type(:uuid).with_options(null: false) }

    it do
      expect(message)
        .to belong_to(:recipient)
        .class_name('User')
        .with_foreign_key('recipient_id')
        .inverse_of(:received_messages)
        .counter_cache(:received_messages_count)
    end
  end
end
