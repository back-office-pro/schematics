# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::NotifyJob do
  include_context 'with user'

  let(:comment) { Comment.create!(author: user, record: user, content: 'Hello!') }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(comment, 'mention', user) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .with(comment, 'mention', user)
        .on_queue('low')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(comment, 'mention', user) }

    it 'creates a new version' do
      expect { perform_now }.to change(Schematics::Version, :count).by(1)
    end
  end
end
