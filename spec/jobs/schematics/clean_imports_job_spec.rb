# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CleanImportsJob do
  include_context 'with import'

  let(:created_at) { described_class::DELAY.ago }
  let(:imports) do
    [
      Import.create!(file:, model:, author: user, created_at:),
      Import.create!(file:, model:, author: user, created_at:)
    ]
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class)
    end
  end

  describe '#perform_now' do
    before { imports }

    context 'when imports are in progress' do
      it 'does not archive imports' do
        expect { described_class.perform_now }.not_to change(Import, :count)
      end

      it 'does not destroy imports' do
        expect { described_class.perform_now }.not_to change(Import.with_deleted, :count)
      end
    end

    context 'when imports are finished' do
      before { imports.each(&:state_finished!) }

      it 'archives imports' do
        expect { described_class.perform_now }
          .to change(Import, :count)
          .by(-2)
      end

      it 'does not destroy imports' do
        expect { described_class.perform_now }.not_to change(Import.with_deleted, :count)
      end
    end

    context 'when imports are in error' do
      before { imports.each(&:state_error!) }

      it 'archives imports' do
        expect { described_class.perform_now }
          .to change(Import, :count)
          .by(-2)
      end

      it 'does not destroy imports' do
        expect { described_class.perform_now }.not_to change(Import.with_deleted, :count)
      end
    end
  end
end
