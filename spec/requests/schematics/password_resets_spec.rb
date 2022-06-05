# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Password Resets' do
  include_context 'with unauthenticated user'

  describe 'POST #create' do
    let(:do_request) { post(password_resets_path, params:, headers:) }
    let(:params) { { user: { email: } } }

    context 'when email exists' do
      let(:email) { 'john.doe@nowhere.com' }

      before { do_request }

      it { is_expected.to have_http_status(:no_content) }
      its(:body) { is_expected.to be_blank }
    end

    context 'when email does not exist' do
      let(:email) { 'foo@foo.com' }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.password_resets.create.failure')
          ]
        }
      end

      before { do_request }

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { expect(json_response).to eq(expected_response) }
    end
  end

  describe 'PUT #update' do
    let(:do_request) { put(password_reset_path(token:), params:, headers:) }
    let(:params) { { user: { password:, password_confirmation: } } }

    context 'when not expired token exists and password is confirmed' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:token) { user.password_reset_token }
      let(:password) { 'Azerty1!' }
      let(:password_confirmation) { 'Azerty1!' }
      let(:reset_password_sent_at) { Time.current }

      before { do_request }

      it { is_expected.to have_http_status(:no_content) }
      its(:body) { is_expected.to be_blank }
    end

    context 'when not expired token exists and password is not confirmed' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:token) { user.password_reset_token }
      let(:password) { 'Azerty1!' }
      let(:password_confirmation) { 'Azerty1' }
      let(:reset_password_sent_at) { Time.current }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.password_resets.update.failure')
          ]
        }
      end

      before { do_request }

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { expect(json_response).to eq(expected_response) }
    end

    context 'when token has expired' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:token) { user.password_reset_token }
      let(:password) { 'Azerty1!' }
      let(:password_confirmation) { 'Azerty1!' }
      let(:reset_password_sent_at) { Time.current - User::PASSWORD_RESET_TOKEN_DURATION }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.password_resets.update.expired')
          ]
        }
      end

      before { do_request }

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { expect(json_response).to eq(expected_response) }
    end

    context 'when token does not exist' do
      let(:token) { 'foo' }
      let(:params) { {} }

      before { do_request }

      it { is_expected.to have_http_status(:not_found) }
      its(:body) { is_expected.to be_blank }
    end
  end
end
