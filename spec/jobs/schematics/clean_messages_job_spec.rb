# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanMessagesJob do
  include_context 'with user'

  let(:created_at) { described_class::DELAY.ago }
  let(:messages) do
    [
      Message.create!(
        subject: 'First message',
        content: 'Lorem',
        author: user,
        recipients: [user]
      ),
      Message.create!(
        subject: 'Second message',
        content: 'Lorem',
        author: user,
        recipients: [user]
      )
    ]
  end
  let(:versions) do
    [
      Schematics::Version.create!(
        event: 'show',
        item: messages.first,
        user:,
        created_at:
      ),
      Schematics::Version.create!(
        event: 'show',
        item: messages.second,
        user:,
        created_at:
      )
    ]
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }
        .to have_enqueued_job(described_class)
        .on_queue('cleanups')
    end
  end

  describe '#perform_now' do
    before { messages }

    context 'when messages are not read' do
      it 'does not archive messages' do
        expect { described_class.perform_now }.not_to change(Message, :count)
      end

      it 'does not destroy messages' do
        expect { described_class.perform_now }.not_to change(Message.with_deleted, :count)
      end
    end

    context 'when messages are read' do
      before { versions }

      it 'archives messages' do
        expect { described_class.perform_now }
          .to change(Message, :count)
          .by(-2)
      end

      it 'does not destroy messages' do
        expect { described_class.perform_now }.not_to change(Message.with_deleted, :count)
      end
    end
  end
end
