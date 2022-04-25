# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::GenerateCsvJob do
  fixtures :users

  let(:file) { Tempfile.new('users.csv') }
  let(:filepath) { file.path }
  let(:model_name) { 'User' }
  let(:preferences) { {} }
  let(:resource_ids) { User.ids }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(model_name, resource_ids, preferences, filepath) }
        .to have_enqueued_job(described_class)
        .with(model_name, resource_ids, preferences, filepath)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) do
      described_class.perform_now(model_name, resource_ids, preferences, filepath)
    end

    it 'writes to file' do
      expect { perform_now }.to(change { File.size(filepath) })
    end

    it 'queues the delete job' do
      expect { perform_now }
        .to have_enqueued_job(Schematics::DeleteTempFileJob)
        .with(filepath)
    end
  end
end
