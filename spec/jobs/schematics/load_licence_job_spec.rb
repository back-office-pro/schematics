# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::LoadLicenceJob do
  let(:licence) { Licence.instance.tap(&:save!) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }
        .to have_enqueued_job(described_class)
        .on_queue('default')
    end
  end

  describe '#perform_now' do
    include_context 'with stripe stubs'

    it 'loads licence from gateway' do
      expect { described_class.perform_now }.to(change { licence.reload.metadata })
    end
  end
end
