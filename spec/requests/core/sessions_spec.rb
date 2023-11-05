# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, except: %i[create destroy] do
  include Schematics::Specs::Request

  describe 'POST #create' do
    include_context 'with unauthenticated user'

    let(:do_request) { post(url, params:, headers:) }
    let(:url) { Rails.application.routes.url_helpers.sessions_path }
    let(:params) { { session: { email:, password:, remember_me: } } }

    context 'when credentials are correct' do
      let(:email) { 'john.doe@nowhere.com' }
      let(:password) { 'Azerty1234?!' }
      let(:remember_me) { true }
      let(:auth_token) { JWT::AuthToken.encode(Session.last.auth_token) }

      before { do_request }

      after { cookies.delete(:auth_token) }

      it { is_expected.to have_http_status(:success) }
      it { expect(json_response).to eq('auth_token' => auth_token) }
      it { expect(cookies[:auth_token]).not_to be_nil }
    end

    context 'when credentials are wrong' do
      let(:email) { 'john.doe@nowhere.com' }
      let(:password) { 'qwerty' }
      let(:remember_me) { false }

      before { do_request }

      it { is_expected.to have_http_status(:unauthorized) }
      it { expect(cookies[:auth_token]).to be_nil }
      its(:body) { is_expected.to eq("HTTP Token: Access denied.\n") }
    end

    context 'when brute forcing credentials' do
      let(:email) { 'john.doe@nowhere.com' }
      let(:password) { 'qwerty' }
      let(:remember_me) { false }
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

      before do
        allow(Rack::Attack.cache).to receive(:store).and_return(memory_store)
        10.times { post(url, params:, headers:) }
      end

      it { is_expected.to have_http_status(:too_many_requests) }
    end

    context 'when login with an existing omniauth account' do
      let(:email) { 'john.doe@nowhere.com' }
      let(:password) { nil }
      let(:remember_me) { nil }
      let(:auth_token) { JWT::AuthToken.encode(Session.last.auth_token) }

      before do
        Rails.application.env_config['omniauth.auth'] = OmniAuth::AuthHash.new({ info: { email: } })
        do_request
      end

      it { is_expected.to have_http_status(:success) }
      it { expect(json_response).to eq('auth_token' => auth_token) }
      it { expect(cookies[:auth_token]).to be_nil }
    end

    context 'when login with a non existing omniauth account' do
      let(:email) { 'jane.doe@nowhere.com' }
      let(:password) { nil }
      let(:remember_me) { nil }

      before do
        Rails.application.env_config['omniauth.auth'] = OmniAuth::AuthHash.new({ info: { email: } })
        do_request
      end

      it { is_expected.to have_http_status(:unauthorized) }
      it { expect(cookies[:auth_token]).to be_nil }
      its(:body) { is_expected.to eq("HTTP Token: Access denied.\n") }
    end

    context 'when impersonating with admin role' do
      include_context 'with authenticated user'
      include_context 'with admin role'

      let(:role) { admin_role }
      let(:email) { other_user.email }
      let(:password) { nil }
      let(:remember_me) { nil }
      let(:other_user) { User.create!(email: 'jane.doe@nowhere.com', role: other_role) }
      let(:other_role) do
        Role.create!(
          name: 'Manager',
          permissions: [Permission.create!(action: 'index', model: 'Import')]
        )
      end
      let(:other_auth_token) { JWT::AuthToken.encode(Session.last.auth_token) }

      before { [other_user, do_request] }

      it { is_expected.to have_http_status(:success) }
      it { expect(json_response).to eq('auth_token' => other_auth_token) }
      it { expect(cookies[:auth_token]).to be_nil }
    end
  end
end
