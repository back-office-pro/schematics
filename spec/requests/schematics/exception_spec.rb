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

RSpec.describe 'Exception' do
  include_context 'with unauthenticated user'

  describe '404' do
    let(:do_request) { get(not_found_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:not_found) }
    its(:body) { is_expected.to be_blank }
  end

  describe '500' do
    let(:do_request) { get(internal_server_error_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:internal_server_error) }
    its(:body) { is_expected.to be_blank }
  end

  describe '503' do
    let(:do_request) { get(maintenance_mode_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:service_unavailable) }
    its(:body) { is_expected.to be_blank }
  end

  describe 'GET #offline' do
    let(:do_request) { get(offline_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end
end
