# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Password Resets' do
  include Schematics::Engine.routes.url_helpers

  subject { response }

  fixtures :users
  fixtures :roles

  let(:json_response) { JSON.parse(response.body) }
  let(:user) { users(:two) }
  let(:email) { user.email }
  let(:headers) { { 'Accept' => 'application/json' } }
  let(:auth_token) { JsonWebToken.encode(auth_token: user.auth_token) }

  before { do_request }

  describe 'POST #create' do
    let(:do_request) { post(password_resets_path, params:, headers:) }
    let(:params) { { user: { email: } } }

    context 'when email exists' do
      let(:email) { user.email }

      it { is_expected.to have_http_status(:no_content) }
      it { expect(response.body).to be_blank }
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

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { expect(json_response).to eq(expected_response) }
    end
  end

  describe 'PUT #update' do
    let(:do_request) { put(password_reset_path(id:), params:, headers:) }
    let(:params) { { user: { password:, password_confirmation: } } }

    context 'when token exists' do
      let(:id) { user.password_reset_token }

      context 'when password is confirmed' do
        let(:password) { 'Azerty1!' }
        let(:password_confirmation) { 'Azerty1!' }

        it { is_expected.to have_http_status(:no_content) }
        it { expect(response.body).to be_blank }
      end

      context 'when password is not confirmed' do
        let(:password) { 'Azerty1!' }
        let(:password_confirmation) { 'Azerty1' }
        let(:expected_response) do
          {
            'errors' => [
              I18n.t('schematics.resources.update.failure')
            ]
          }
        end

        it { is_expected.to have_http_status(:unprocessable_entity) }
        it { expect(json_response).to eq(expected_response) }
      end
    end

    context 'when token does not exist' do
      let(:id) { 'foo' }

      it { is_expected.to have_http_status(:not_found) }
      it { expect(response.body).to be_blank }
    end
  end
end
