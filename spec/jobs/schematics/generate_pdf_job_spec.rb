# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::GeneratePdfJob do
  fixtures :users

  let(:file) { Tempfile.new('user.pdf') }
  let(:filepath) { file.path }
  let(:model_name) { 'User' }
  let(:user) { users(:one) }
  let(:resource_id) { user.id }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(model_name, resource_id, filepath) }
        .to have_enqueued_job(described_class)
        .with(model_name, resource_id, filepath)
    end
  end

  describe '#perform_now' do
    it 'writes to file' do
      expect { described_class.perform_now(model_name, resource_id, filepath) }
        .to(change { File.size(filepath) })
    end

    it 'queues the delete job' do
      expect { described_class.perform_now(model_name, resource_id, filepath) }
        .to have_enqueued_job(Schematics::DeleteTempFileJob)
        .with(filepath)
    end
  end
end
