# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanTasksJob do
  include_context 'with user'

  let(:created_at) { described_class::DELAY.ago }
  let(:tasks) do
    [
      Task.create!(title: 'First task', applicant: user, assigneds: [user], created_at:),
      Task.create!(title: 'Second task', applicant: user, assigneds: [user], created_at:)
    ]
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class)
    end
  end

  describe '#perform_now' do
    before { tasks }

    context 'when tasks are pending' do
      it 'does not archive tasks' do
        expect { described_class.perform_now }.not_to change(Task, :count)
      end

      it 'does not destroy tasks' do
        expect { described_class.perform_now }.not_to change(Task.with_deleted, :count)
      end
    end

    context 'when tasks are in progress' do
      before { tasks.each(&:start!) }

      it 'does not archive tasks' do
        expect { described_class.perform_now }.not_to change(Task, :count)
      end

      it 'does not destroy tasks' do
        expect { described_class.perform_now }.not_to change(Task.with_deleted, :count)
      end
    end

    context 'when tasks are completed' do
      before do
        tasks.each(&:start!)
        tasks.each(&:complete!)
      end

      it 'archives tasks' do
        expect { described_class.perform_now }
          .to change(Task, :count)
          .by(-2)
      end

      it 'does not destroy tasks' do
        expect { described_class.perform_now }.not_to change(Task.with_deleted, :count)
      end
    end

    context 'when tasks are aborted' do
      before do
        tasks.each(&:start!)
        tasks.each(&:abort!)
      end

      it 'archives tasks' do
        expect { described_class.perform_now }
          .to change(Task, :count)
          .by(-2)
      end

      it 'does not destroy tasks' do
        expect { described_class.perform_now }.not_to change(Task.with_deleted, :count)
      end
    end
  end
end
