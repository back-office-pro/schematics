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

RSpec.describe 'Tokens' do
  include_context 'with authenticated user'

  describe 'POST #create' do
    let(:do_request) { post(tokens_path, params:, headers:) }
    let(:params) { { refresh_token: } }

    before { do_request }

    context 'when token is correct' do
      let(:refresh_token) { session.generate_token_for(:refresh_token) }
      let(:expected_response) do
        {
          'token_type' => 'Bearer',
          'expires_in' => 600,
          'access_token' => String,
          'refresh_token' => String
        }
      end

      it { is_expected.to have_http_status(:success) }
      its(:parsed_body) { is_expected.to match(expected_response) }
    end

    context 'when token is wrong' do
      let(:refresh_token) { 'abcd' }

      it { is_expected.to have_http_status(:bad_request) }
      its(:body) { is_expected.to be_blank }
    end
  end
end
