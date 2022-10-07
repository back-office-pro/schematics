# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanSessionsJob do
  include_context 'with user'

  let(:created_at) { described_class::DELAY.ago }
  let(:sessions) do
    [
      Session.create!(user:, created_at:),
      Session.create!(user:, created_at:)
    ]
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class)
    end
  end

  describe '#perform_now' do
    before { sessions }

    it 'cleans sessions' do
      expect { described_class.perform_now }.to change(Session, :count).by(-2)
    end
  end
end
