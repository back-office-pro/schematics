# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::ImportJob do
  include_context 'with import'

  it { is_expected.to be_a(Schematics::Quietable) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(import) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .with(import)
        .on_queue('default')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(import) }

    context 'when there is no import error' do
      it 'imports the resources' do
        expect { perform_now }.to change(import.model_class, :count).by(2)
      end

      it 'changes import state from pending to finished' do
        expect { perform_now }
          .to change { import.reload.state }
          .from('pending')
          .to('finished')
      end
    end

    context 'when there are import errors' do
      let(:model) { 'Permission' }

      it 'does not import resources' do
        expect { perform_now }.not_to change(import.model_class, :count)
      end

      it 'changes import state from pending to error' do
        expect { perform_now }
          .to change { import.reload.state }
          .from('pending')
          .to('error')
      end

      it 'stores import errors' do
        expect { perform_now }
          .to change { import.reload.import_errors }
          .to match('Line 1' => String, 'Line 2' => String)
      end
    end

    context 'when there is a file not found error' do
      before do
        allow(import.file)
          .to receive(:download)
          .and_raise(ActiveStorage::FileNotFoundError)
      end

      it 'changes import state from pending to error after discard' do
        expect { perform_now }
          .to change { import.reload.state }
          .from('pending')
          .to('error')
      end
    end
  end
end
