# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::GeneratePDFJob do
  include Turbo::Broadcastable::TestHelper
  include_context 'with user'

  let(:resource) { user }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(user, resource) }
        .to have_enqueued_job(described_class)
        .with(user, resource)
        .on_queue('exports')
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(user, resource) }

    let(:stream) do
      capture_turbo_stream_broadcasts([user, :generate_file_in_background]) { perform_now }
    end

    it 'uploads a blob' do
      expect { perform_now }
        .to change(ActiveStorage::Blob, :count)
        .by(1)
    end

    it 'queues the purge job' do
      expect { perform_now }
        .to have_enqueued_job(ActiveStorage::PurgeJob)
        .with(an_instance_of(ActiveStorage::Blob))
        .on_queue('cleanups')
    end

    it 'broadcasts replace to user' do
      expect(stream.first['action']).to eq('replace')
    end

    it 'broadcasts to user target' do
      expect(stream.first['target']).to eq('generate_file_in_background')
    end
  end
end
