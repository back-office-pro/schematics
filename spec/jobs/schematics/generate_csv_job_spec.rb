# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::GenerateCsvJob do
  include_context 'with user'

  let(:resources) { [user] }
  let(:dropdown) { false }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(user, resources, dropdown) }
        .to have_enqueued_job(described_class)
        .with(user, resources, dropdown)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(user, resources, dropdown) }

    it 'uploads a blob' do
      expect { perform_now }
        .to change(ActiveStorage::Blob, :count)
        .by(1)
    end

    it 'queues the purge job' do
      expect { perform_now }
        .to have_enqueued_job(ActiveStorage::PurgeJob)
        .with(an_instance_of(ActiveStorage::Blob))
    end

    xit 'broadcasts to user' do # TODO: enable when supported
      expect { perform_now }
        .to have_broadcasted_to(user)
        .from_channel(Turbo::StreamsChannel)
        .with(a_hash_including(target: 'generate_file_in_background'))
    end
  end
end
