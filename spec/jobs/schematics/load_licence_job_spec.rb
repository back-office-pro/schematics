# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::LoadLicenceJob do
  let(:licence) { Licence.instance }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class)
    end
  end

  describe '#perform_now' do
    it 'loads licence from gateway' do
      expect { described_class.perform_now }.to(change { licence.reload.metadata })
    end
  end
end
