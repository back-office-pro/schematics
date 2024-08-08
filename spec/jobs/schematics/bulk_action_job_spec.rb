# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::BulkActionJob do
  include_context 'with user'

  let(:model_class) { User }
  let(:ids) { [user.id] }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(user, model_class, ids) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('cleanups')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(user, model_class, ids) }

    it 'archives records' do
      expect { perform_now }.to change(model_class, :count).by(-ids.size)
    end
  end
end
