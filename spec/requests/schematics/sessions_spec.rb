# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  describe 'POST #create' do
    include_context 'with unauthenticated user'

    let(:do_request) { post(sessions_path, params:, headers:) }
    let(:params) { { user: { email:, password: } } }

    context 'when credentials are correct' do
      let(:password) { 'secret' }

      it { is_expected.to have_http_status(:success) }
      it { expect(json_response).to eq({ 'auth_token' => auth_token }) }
    end

    context 'when credentials are wrong' do
      let(:password) { 'qwerty' }

      it { is_expected.to have_http_status(:unauthorized) }
      its(:body) { is_expected.to be_blank }
    end
  end

  describe 'PUT #update' do
    include_context 'with authenticated user'

    let(:do_request) { put(sessions_path, params:, headers:) }
    let(:params) { { user: { current_password: } } }

    context 'when current_password is right' do
      let(:current_password) { 'secret' }

      it { is_expected.to have_http_status(:no_content) }
      its(:body) { is_expected.to be_blank }
    end

    context 'when current_password is wrong' do
      let(:current_password) { 'qwerty' }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.sessions.update.failure', locale: user.locale)
          ]
        }
      end

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { expect(json_response).to eq(expected_response) }
    end
  end
end
