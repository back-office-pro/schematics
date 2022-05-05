# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::GenerateCsvJob do
  fixtures :users

  let(:user) { users(:one) }
  let(:user_id) { user.id }
  let(:model_name) { 'User' }
  let(:resource_ids) { User.ids }
  let(:dropdown) { false }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(user_id, model_name, resource_ids, dropdown) }
        .to have_enqueued_job(described_class)
        .with(user_id, model_name, resource_ids, dropdown)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) do
      described_class.perform_now(user_id, model_name, resource_ids, dropdown)
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
    end

    xit 'broadcasts to user' do # TODO: enable when supported
      expect { perform_now }
        .to have_broadcasted_to(user)
        .from_channel(Turbo::StreamsChannel)
        .with(a_hash_including(target: 'generate_file_in_background'))
    end
  end
end
