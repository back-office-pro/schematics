# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  describe 'POST #create' do
    include_context 'with unauthenticated user'

    let(:do_request) { post(sessions_path, params:, headers:) }
    let(:params) { { session: { email:, password: } } }

    context 'when credentials are correct' do
      let(:email) { 'john.doe@nowhere.com' }
      let(:password) { 'Azerty1!' }
      let(:auth_token) { JsonWebToken.encode(auth_token: Session.last.auth_token) }

      before { do_request }

      it { is_expected.to have_http_status(:success) }
      it { expect(json_response).to eq('auth_token' => auth_token) }
    end

    context 'when credentials are wrong' do
      let(:email) { 'john.doe@nowhere.com' }
      let(:password) { 'qwerty' }

      before { do_request }

      it { is_expected.to have_http_status(:unauthorized) }
      its(:body) { is_expected.to be_blank }
    end
  end
end
