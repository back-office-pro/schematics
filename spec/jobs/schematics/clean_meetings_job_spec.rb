# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanMeetingsJob do
  include_context 'with user'

  let(:end_at) { described_class::DELAY.ago }
  let(:meetings) do
    [
      Meeting.create!(
        subject: 'First meeting',
        creator: user,
        start_at: end_at.yesterday,
        end_at:,
        participants: [user]
      ),
      Meeting.create!(
        subject: 'Second meeting',
        creator: user,
        start_at: end_at.yesterday,
        end_at:,
        participants: [user]
      )
    ]
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class)
    end
  end

  describe '#perform_now' do
    before { meetings }

    it 'archives meetings' do
      expect { described_class.perform_now }
        .to change(Meeting, :count)
        .by(-2)
    end

    it 'does not destroy meetings' do
      expect { described_class.perform_now }.not_to change(Meeting.with_deleted, :count)
    end
  end
end
