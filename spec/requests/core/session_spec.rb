# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Demo::Session, except: %i[create destroy] do
  include Schematics::Specs::Request

  describe 'POST #create' do
    include_context 'with unauthenticated user'

    let(:do_request) { post(url, params:, headers:) }
    let(:url) { resources_path(described_class) }
    let(:params) { { session: { email:, password:, remember_me: } } }
    let(:expected_response) do
      {
        'token_type' => 'Bearer',
        'expires_in' => 600,
        'access_token' => String,
        'refresh_token' => String
      }
    end

    context 'when credentials are correct' do
      let(:email) { 'john.doe@nowhere.com' }
      let(:password) { Schematics::Attributes::Digest::DEFAULT }
      let(:remember_me) { true }

      before { do_request }

      after { cookies.delete(:access_token) }

      it { is_expected.to have_http_status(:success) }
      it { expect(cookies[:access_token]).not_to be_nil }
      its(:parsed_body) { is_expected.to match(expected_response) }
    end

    context 'when credentials are wrong' do
      let(:email) { 'john.doe@nowhere.com' }
      let(:password) { 'qwerty' }
      let(:remember_me) { false }

      before { do_request }

      it { is_expected.to have_http_status(:unauthorized) }
      it { expect(cookies[:access_token]).to be_nil }
      its(:body) { is_expected.to eq("HTTP Token: Access denied.\n") }
    end

    context 'when brute forcing credentials' do
      let(:email) { 'john.doe@nowhere.com' }
      let(:password) { 'qwerty' }
      let(:remember_me) { false }

      before { 10.times { post(url, params:, headers:) } }

      it { is_expected.to have_http_status(:too_many_requests) }
    end

    context 'when login with an existing omniauth account' do
      let(:email) { 'john.doe@nowhere.com' }
      let(:password) { nil }
      let(:remember_me) { nil }

      before do
        Rails.application.env_config['omniauth.auth'] = OmniAuth::AuthHash.new(info: { email: })
        do_request
      end

      after { Rails.application.env_config['omniauth.auth'] = nil }

      it { is_expected.to have_http_status(:success) }
      it { expect(cookies[:access_token]).to be_nil }
      its(:parsed_body) { is_expected.to match(expected_response) }
    end

    context 'when login with a non existing omniauth account' do
      let(:email) { 'jane.doe@nowhere.com' }
      let(:password) { nil }
      let(:remember_me) { nil }

      before do
        Rails.application.env_config['omniauth.auth'] = OmniAuth::AuthHash.new(info: { email: })
        do_request
      end

      after { Rails.application.env_config['omniauth.auth'] = nil }

      it { is_expected.to have_http_status(:unauthorized) }
      it { expect(cookies[:access_token]).to be_nil }
      its(:body) { is_expected.to eq("HTTP Token: Access denied.\n") }
    end

    context 'when impersonating with admin role' do
      include_context 'with authenticated user'

      let(:role) { @role }
      let(:session) { @session }
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

      before { [other_user, do_request] }

      it { is_expected.to have_http_status(:success) }
      it { expect(cookies[:access_token]).to be_nil }
      its(:parsed_body) { is_expected.to match(expected_response) }
    end
  end
end
