# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OneTimePasswords' do
  include_context 'with authenticated user'

  describe 'GET #new' do
    let(:do_request) { get(new_one_time_passwords_path, headers:) }
    let(:accept_header) { 'text/html' }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end

  describe 'POST #create' do
    let(:do_request) { post(one_time_passwords_path, params:, headers:) }
    let(:params) { { one_time_password: { attempt:, secret: } } }

    before { do_request }

    context 'when attempt is wrong' do
      let(:secret) { ROTP::Base32.random }
      let(:attempt) { '123456' }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.one_time_passwords.create.failure')
          ]
        }
      end

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { expect(json_response).to eq(expected_response) }
    end
  end

  describe 'DELETE #destroy' do
    let(:do_request) { delete(one_time_passwords_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:no_content) }
    its(:body) { is_expected.to be_blank }
  end
end
