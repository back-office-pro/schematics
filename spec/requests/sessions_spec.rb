# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  describe 'POST #create' do
    include_context 'with unauthenticated user'

    let(:do_request) { post(sessions_path, params:, headers:) }
    let(:params) { { session: { email:, password: } } }

    context 'when credentials are correct' do
      let(:password) { 'Azerty1!' }

      before { do_request }

      it { is_expected.to have_http_status(:success) }
      it { expect(json_response).to eq('auth_token' => auth_token) }
    end

    context 'when credentials are wrong' do
      let(:password) { 'qwerty' }

      before { do_request }

      it { is_expected.to have_http_status(:unauthorized) }
      its(:body) { is_expected.to be_blank }
    end
  end
end
