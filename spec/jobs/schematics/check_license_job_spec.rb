# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CheckLicenseJob do
  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('critical')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now }

    let(:license_heartbeat_stub_request) do
      stub_request(:post, 'https://www.back-office.pro/license/heartbeat').to_return(status:)
    end

    before do
      allow(Configuration).to receive(:license).and_call_original
      license_heartbeat_stub_request
    end

    context 'when the server responds to a valid license' do
      let(:status) { 200 }

      it 'sends license data to the server' do
        perform_now
        expect(license_heartbeat_stub_request).to have_been_requested.once
      end
    end

    context 'when the server responds to an invalid license' do
      let(:status) { 401 }

      it 'sends license data to the server' do
        perform_now
        expect(license_heartbeat_stub_request).to have_been_requested.once
      end

      it 'invalidates the license' do
        expect { perform_now }.to change(Configuration, :license)
      end
    end
  end
end
