# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OneTimePasswords' do
  include_context 'with authenticated user'

  describe 'GET #show' do
    let(:do_request) { get(one_time_passwords_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
    its(:body) { is_expected.to be_blank }
  end

  describe 'GET #edit' do
    let(:do_request) { get(edit_one_time_passwords_path, headers:) }
    let(:accept_header) { 'text/html' }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end

  describe 'POST #create' do
    include_context 'with unauthenticated user'

    let(:do_request) { post(one_time_passwords_path, params:, headers:) }
    let(:params) { { user: { otp_token:, otp_attempt_digits:, remember_me: } } }

    before { do_request }

    context 'when attempt is correct' do
      let(:otp_token) { user.generate_token_for(:one_time_password) }
      let(:otp_attempt_digits) { user.otp_code_chars }
      let(:remember_me) { true }
      let(:expected_response) do
        {
          'token_type' => 'Bearer',
          'expires_in' => 600,
          'access_token' => String,
          'refresh_token' => String
        }
      end

      after { cookies.delete(:access_token) }

      it { is_expected.to have_http_status(:success) }
      it { expect(cookies[:access_token]).not_to be_nil }
      its(:parsed_body) { is_expected.to match(expected_response) }
    end

    context 'when attempt is wrong' do
      let(:otp_token) { user.generate_token_for(:one_time_password) }
      let(:otp_attempt_digits) { %w[abcd] }
      let(:remember_me) { false }

      it { is_expected.to have_http_status(:unauthorized) }
      it { expect(cookies[:access_token]).to be_nil }
      its(:body) { is_expected.to eq("HTTP Token: Access denied.\n") }
    end
  end

  describe 'PUT #update' do
    let(:do_request) { put(one_time_passwords_path, params:, headers:) }
    let(:params) { { user: { otp_attempt_digits: } } }

    before { do_request }

    context 'when attempt is correct' do
      let(:otp_attempt_digits) { user.otp_code_chars }

      it { is_expected.to have_http_status(:no_content) }
      its(:body) { is_expected.to be_blank }
    end

    context 'when attempt is wrong' do
      let(:otp_attempt_digits) { %w[abcd] }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.one_time_passwords.update.failure')
          ]
        }
      end

      it { is_expected.to have_http_status(:unprocessable_content) }
      its(:parsed_body) { is_expected.to eq(expected_response) }
    end
  end

  describe 'DELETE #destroy' do
    let(:do_request) { delete(one_time_passwords_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:no_content) }
    its(:body) { is_expected.to be_blank }
  end
end
