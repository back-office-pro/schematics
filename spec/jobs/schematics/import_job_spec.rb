# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::ImportJob do
  include_context 'with import'

  let(:model_name) { model_class.to_s }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(import.id, model_name) }
        .to have_enqueued_job(described_class)
        .with(import.id, model_name)
    end
  end

  describe '#perform_now' do
    it 'imports the roles' do
      expect { described_class.perform_now(import.id, model_name) }
        .to change { import.reload.status }.from('pending').to('finished')
    end
  end
end
