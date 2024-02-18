# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::NotifyMentionsJob do
  include_context 'with user'

  let(:comment) { Comment.create!(author: user, record: user, content: 'Hello!') }

  before { allow(comment).to receive(:mentions).and_return([user]) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(comment) }
        .to have_enqueued_job(described_class)
        .with(comment)
        .on_queue('notifications')
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(comment) }

    it 'creates a new version' do
      expect { perform_now }.to change(Schematics::Version, :count).by(1)
    end
  end
end
