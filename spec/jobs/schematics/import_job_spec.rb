# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::ImportJob do
  include_context 'with import'

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(import, model_class) }
        .to have_enqueued_job(described_class)
        .with(import, model_class)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(import, model_class) }

    context 'when there are no import error' do
      it 'imports the resources' do
        expect { perform_now }.to change(model_class, :count).by(2)
      end

      it 'changes the import status from pending to finished' do
        expect { perform_now }
          .to change { import.reload.status }
          .from('pending')
          .to('finished')
      end
    end

    context 'when there are import errors' do
      let(:model_class) { Permission }

      it 'does not import the resources' do
        expect { perform_now }.not_to change(model_class, :count)
      end

      it 'changes the import status from pending to error' do
        expect { perform_now }
          .to change { import.reload.status }
          .from('pending')
          .to('error')
      end

      it 'stores the import errors' do
        expect { perform_now }
          .to change { import.reload.import_errors }
          .to match('Line 1' => String, 'Line 2' => String)
      end
    end
  end
end
