# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  describe 'POST #create' do
    include_context 'with unauthenticated user'

    let(:do_request) { post(sessions_path, params:, headers:) }
    let(:params) { { session: { email:, password:, remember_me: } } }

    context 'when credentials are correct' do
      let(:email) { 'john.doe@nowhere.com' }
      let(:password) { 'Azerty1!' }
      let(:remember_me) { true }
      let(:exp) { 24.hours.from_now.to_i }
      let(:auth_token) { JsonWebToken.encode(auth_token: Session.last.auth_token, exp:) }

      before { do_request }

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
      its(:body) { is_expected.to be_blank }
    end
  end
end
