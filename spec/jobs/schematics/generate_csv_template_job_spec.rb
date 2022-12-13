# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::GenerateCsvTemplateJob do
  include_context 'with user'

  let(:model_class) { User }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(user, model_class) }
        .to have_enqueued_job(described_class)
        .with(user, model_class)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(user, model_class) }

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

    it 'broadcasts to user', skip: 'not supported' do
      expect { perform_now }
        .to have_broadcasted_to(user)
        .from_channel(Turbo::StreamsChannel)
        .with(a_hash_including(target: 'generate_file_in_background'))
    end
  end
end
