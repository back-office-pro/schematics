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

RSpec.describe Configuration do
  include Schematics::Specs::Model

  before do
    allow(BootstrapEmail).to receive(:clear_sass_cache!).and_return(nil)
    allow(described_class).to receive(:license).and_call_original
  end

  after do
    ActiveStorage::Blob.service = ActiveStorage::Blob.services.fetch(:test)
  end

  it 'clears bootstrap email cache after update' do
    record.tap(&:save!).reload.update!(theme_color: '#ffffff')
    expect(BootstrapEmail).to have_received(:clear_sass_cache!)
  end

  it 'updates the storage service after update' do
    expect { record.tap(&:save!).reload.update!(aws_bucket: 'test') }
      .to change { ActiveStorage::Blob.service.name }
      .from(:test)
      .to(:amazon)
  end

  describe '.time_zone_with_fallback' do
    subject { described_class.time_zone_with_fallback }

    it { is_expected.to eq('UTC') }
  end

  describe '.default_url_options' do
    subject { described_class.default_url_options }

    it { is_expected.to eq(host: 'localhost', port: 3000) }
  end

  describe '.allowed_sources' do
    subject { described_class.allowed_sources }

    it { is_expected.to be_empty }
  end

  describe '.storage_quota_will_be_exceeded?' do
    subject { described_class.storage_quota_will_be_exceeded?(size) }

    let(:size) { 2_000 }

    it { is_expected.to be_falsy }
  end

  describe '.license' do
    subject { described_class.license }

    it { is_expected.to be_a(Schematics::License) }
  end

  describe '.license_file' do
    subject { described_class.license_file }

    it { is_expected.to be_nil }
  end
end
