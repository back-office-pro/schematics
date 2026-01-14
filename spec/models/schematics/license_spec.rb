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

RSpec.describe Schematics::License do
  subject(:license) { described_class.new(expires_at:, fingerprint:, signature:) }

  let(:expires_at) { 1_798_062_114 }
  let(:fingerprint) { 'test' }
  let(:signature) { 'test' }

  it { is_expected.not_to be_active }
  it { is_expected.not_to be_users_quota_exceeded }
  it { is_expected.not_to be_webhooks_quota_exceeded }
  it { is_expected.not_to be_api_keys_quota_exceeded }
  it { is_expected.not_to be_roles_quota_exceeded }
  it { is_expected.not_to be_teams_quota_exceeded }

  describe '.storage_quota_will_be_exceeded?' do
    subject { license.storage_quota_will_be_exceeded?(size) }

    context 'when size is greater than storage quota' do
      let(:size) { 2.gigabytes }

      it { is_expected.to be_truthy }
    end

    context 'when size is lower than storage quota' do
      let(:size) { 2.bytes }

      it { is_expected.to be_falsy }
    end
  end

  describe '.entities_quota_will_be_exceeded?' do
    subject { license.entities_quota_will_be_exceeded?(size) }

    context 'when size is greater than entities quota' do
      let(:size) { 20 }

      it { is_expected.to be_truthy }
    end

    context 'when size is lower than entities quota' do
      let(:size) { 2 }

      it { is_expected.to be_falsy }
    end
  end
end
