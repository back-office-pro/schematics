# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OneTimePassword' do
  include_context 'with authenticated user'

  describe 'GET #edit' do
    let(:do_request) { get(edit_one_time_password_path, headers:) }
    let(:accept_header) { 'text/html' }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end

  describe 'PUT #update' do
    let(:do_request) { put(one_time_password_path, params:, headers:) }
    let(:params) { { user: { otp_attempt: } } }

    before { do_request }

    context 'when attempt is correct' do
      let(:otp_attempt) { user.otp_code }

      it { is_expected.to have_http_status(:no_content) }
      its(:body) { is_expected.to be_blank }
    end

    context 'when attempt is wrong' do
      let(:otp_attempt) { 'abcd' }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.one_time_password.update.failure')
          ]
        }
      end

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { expect(json_response).to eq(expected_response) }
    end
  end

  describe 'DELETE #destroy' do
    let(:do_request) { delete(one_time_password_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:no_content) }
    its(:body) { is_expected.to be_blank }
  end
end
