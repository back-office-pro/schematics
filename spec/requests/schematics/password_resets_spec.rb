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

RSpec.describe 'PasswordResets' do
  include ActiveSupport::Testing::TimeHelpers

  include_context 'with unauthenticated user'

  describe 'POST #create' do
    let(:do_request) { post(password_resets_path, params:, headers:) }
    let(:params) { { user: { email: } } }

    context 'when email exists' do
      let(:email) { 'john.doe@nowhere.com' }

      before { do_request }

      it { is_expected.to have_http_status(:created) }
      its(:body) { is_expected.to be_blank }
    end

    context 'when email does not exist' do
      let(:email) { 'foo@foo.com' }

      before { do_request }

      it { is_expected.to have_http_status(:created) }
      its(:body) { is_expected.to be_blank }
    end

    context 'when enumerating accounts' do
      let(:email) { 'foo@foo.com' }

      before { 10.times { post(password_resets_path, params:, headers:) } }

      it { is_expected.to have_http_status(:too_many_requests) }
    end
  end

  describe 'PUT #update' do
    let(:do_request) { put(password_reset_path(token:), params:, headers:) }
    let(:params) { { user: { password:, password_confirmation: } } }

    context 'when not expired token exists and password is confirmed' do
      let(:token) { user.generate_token_for(:password_reset) }
      let(:password) { Schematics::Attributes::Digest::DEFAULT }
      let(:password_confirmation) { Schematics::Attributes::Digest::DEFAULT }

      before { do_request }

      it { is_expected.to have_http_status(:no_content) }
      its(:body) { is_expected.to be_blank }
    end

    context 'when using the new account token and password is confirmed' do
      let(:token) { user.generate_token_for(:new_account) }
      let(:password) { Schematics::Attributes::Digest::DEFAULT }
      let(:password_confirmation) { Schematics::Attributes::Digest::DEFAULT }

      before { do_request }

      it { is_expected.to have_http_status(:no_content) }
      its(:body) { is_expected.to be_blank }
    end

    context 'when not expired token exists and password is not confirmed' do
      let(:token) { user.generate_token_for(:password_reset) }
      let(:password) { Schematics::Attributes::Digest::DEFAULT }
      let(:password_confirmation) { 'Azerty1' }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.password_resets.update.failure')
          ]
        }
      end

      before { do_request }

      it { is_expected.to have_http_status(:unprocessable_content) }
      its(:parsed_body) { is_expected.to eq(expected_response) }
    end

    context 'when token has expired' do
      let(:token) { user.generate_token_for(:password_reset) }
      let(:time) { 16.minutes.from_now }
      let(:password) { Schematics::Attributes::Digest::DEFAULT }
      let(:password_confirmation) { Schematics::Attributes::Digest::DEFAULT }

      before { [token, travel_to(time) { do_request }] }

      it { is_expected.to have_http_status(:bad_request) }
      its(:body) { is_expected.to be_blank }
    end

    context 'when token is invalid' do
      let(:token) { 'foo' }
      let(:params) { {} }

      before { do_request }

      it { is_expected.to have_http_status(:bad_request) }
      its(:body) { is_expected.to be_blank }
    end
  end
end
