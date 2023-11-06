# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OneTimePasswords' do
  include_context 'with authenticated user'

  describe 'GET #show' do
    let(:do_request) { get(one_time_passwords_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
    its(:body) { is_expected.to eq('null') }
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
    let(:params) { { user: { otp_token:, otp_attempt:, remember_me: } } }

    before { do_request }

    context 'when attempt is correct' do
      let(:otp_token) { user.generate_token_for(:one_time_password) }
      let(:otp_attempt) { user.otp_code }
      let(:remember_me) { true }
      let(:auth_token) { JWT::AuthToken.encode(Session.last.auth_token) }

      after { cookies.delete(:auth_token) }

      it { is_expected.to have_http_status(:success) }
      it { expect(json_response).to eq('auth_token' => auth_token) }
      it { expect(cookies[:auth_token]).not_to be_nil }
    end

    context 'when attempt is wrong' do
      let(:otp_token) { user.generate_token_for(:one_time_password) }
      let(:otp_attempt) { 'abcd' }
      let(:remember_me) { false }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.one_time_passwords.update.failure')
          ]
        }
      end

      it { is_expected.to have_http_status(:unauthorized) }
      it { expect(cookies[:auth_token]).to be_nil }
      its(:body) { is_expected.to eq("HTTP Token: Access denied.\n") }
    end
  end

  describe 'PUT #update' do
    let(:do_request) { put(one_time_passwords_path, params:, headers:) }
    let(:params) { { user: { otp_attempt: } } }

    before { do_request }

    context 'when attempt is correct' do
      let(:otp_attempt) { user.otp_code }

      it { is_expected.to have_http_status(:no_content) }
      its(:body) { is_expected.to be_blank }
    end

    context 'when attempt is wrong' do
      let(:otp_attempt) { 'abcd' }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.one_time_passwords.update.failure')
          ]
        }
      end

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { expect(json_response).to eq(expected_response) }
    end
  end

  describe 'DELETE #destroy' do
    let(:do_request) { delete(one_time_passwords_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:no_content) }
    its(:body) { is_expected.to be_blank }
  end
end
