# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Guest::User do
  subject(:user) { described_class.new(permissions:, time_zone:, locale:) }

  let(:time_zone) { 'UTC' }
  let(:locale) { 'en' }
  let(:permissions) { [Permission.new(action: 'create', model: 'User')] }

  it { is_expected.not_to be_admin }
  it { is_expected.not_to be_otp_enabled }

  its(:id) { is_expected.to be_nil }
  its(:teams) { is_expected.to be_empty }
  its(:preferences) { is_expected.to be_empty }
  its(:preferences_theme) { is_expected.to be_nil }
  its(:locale) { is_expected.to eq('en') }
  its(:time_zone) { is_expected.to eq('UTC') }
  its(:role) { is_expected.to be_a(Role) }
  its(:provisioning_uri) { is_expected.to be_nil }
  its(:find_or_create_draft!) { is_expected.to be_nil }
  its(:update) { is_expected.to be_falsy }
  its(:authenticate) { is_expected.to be_falsy }
  its(:log_search!) { is_expected.to be_falsy }
end
