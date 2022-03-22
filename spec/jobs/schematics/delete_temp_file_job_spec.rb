# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::DeleteTempFileJob do
  let(:file) { Tempfile.new('users.csv') }
  let(:filepath) { file.path }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(filepath) }
        .to have_enqueued_job(described_class)
        .with(filepath)
    end
  end

  describe '#perform_now' do
    it 'deletes the file' do
      expect { described_class.perform_now(filepath) }
        .to change { File.exist?(filepath) }.from(true).to(false)
    end
  end
end
