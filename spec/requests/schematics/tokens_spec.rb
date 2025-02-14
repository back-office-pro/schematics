# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tokens' do
  include Schematics::Engine.routes.url_helpers
  include_context 'with authenticated user'

  describe 'POST #create' do
    let(:do_request) { post(tokens_path, params:, headers:) }
    let(:params) { { refresh_token: } }

    before { do_request }

    context 'when token is correct' do
      let(:refresh_token) { session.generate_token_for(:refresh_token) }
      let(:expected_response) do
        {
          'token_type' => 'Bearer',
          'expires_in' => 600,
          'access_token' => String,
          'refresh_token' => String
        }
      end

      it { is_expected.to have_http_status(:success) }
      its(:parsed_body) { is_expected.to match(expected_response) }
    end

    context 'when token is wrong' do
      let(:refresh_token) { 'abcd' }

      it { is_expected.to have_http_status(:bad_request) }
      its(:body) { is_expected.to be_blank }
    end
  end
end
