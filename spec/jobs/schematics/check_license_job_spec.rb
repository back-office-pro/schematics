# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
      stub_request(:post, 'https://www.back-office.pro/license_heartbeat').to_return(status:)
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
