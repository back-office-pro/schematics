# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanDraftsJob do
  include_context 'with user'

  let(:created_at) { described_class::DELAY.ago }
  let(:drafts) do
    [
      Draft.create!(record: user, user:, created_at:),
      Draft.create!(record: user, user:, created_at:)
    ]
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class)
    end
  end

  describe '#perform_now' do
    before { drafts }

    it 'destroys drafts' do
      expect { described_class.perform_now }
        .to change(Draft.with_deleted, :count)
        .by(-2)
    end
  end
end
