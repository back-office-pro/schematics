# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  include Schematics::Engine.routes.url_helpers

  subject { response }

  fixtures :users

  let(:json_response) { JSON.parse(response.body) }
  let(:user) { users(:two) }
  let(:email) { user.email }
  let(:headers) { { 'Accept' => 'application/json' } }
  let(:auth_token) { JsonWebToken.encode(auth_token: user.auth_token) }

  before { do_request }

  describe 'POST #create' do
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
      it { expect(response.body).to be_blank }
    end
  end

  describe 'PUT #update' do
    let(:do_request) { put(sessions_path, params:, headers:) }
    let(:headers) do
      {
        'Accept' => 'application/json',
        'Authorization' => auth_token
      }
    end
    let(:params) { { user: { current_password: } } }

    context 'when current_password is right' do
      let(:current_password) { 'secret' }

      it { is_expected.to have_http_status(:no_content) }
      it { expect(response.body).to be_blank }
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
