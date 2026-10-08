# frozen_string_literal: true

require 'rails_helper'
require 'turbo/broadcastable/test_helper'

RSpec.describe Schematics::GeneratePDFJob do
  include ActiveSupport::Testing::TimeHelpers
  include Turbo::Broadcastable::TestHelper

  include_context 'with user'

  let(:resource) { user }

  before { freeze_time }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(user, resource) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .with(user, resource)
        .on_queue('default')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(user, resource) }

    let(:stream) { capture_turbo_stream_broadcasts([user, :generate_file_in_background]) }

    it 'uploads a blob' do
      expect { perform_now }
        .to change(ActiveStorage::Blob, :count)
        .by(1)
    end

    it 'queues the purge job' do
      expect { perform_now }
        .to have_enqueued_job(ActiveStorage::PurgeJob)
        .exactly(:once)
        .with(an_instance_of(ActiveStorage::Blob))
        .on_queue('low')
        .at(Schematics::Resources::GenerateFile::PURGE_WAIT.from_now)
    end

    it 'broadcasts replace to user' do
      perform_now
      expect(stream.first['action']).to eq('replace')
    end

    it 'broadcasts to user target' do
      perform_now
      expect(stream.first['target']).to eq('generate_file_in_background')
    end
  end
end
