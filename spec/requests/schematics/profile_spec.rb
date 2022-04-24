# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profile' do
  include_context 'with authenticated user'

  describe 'PUT #update' do
    let(:do_request) { put(profile_path, params:, headers:) }
    let(:params) { { user: { current_password: } } }

    context 'when current_password is right' do
      let(:current_password) { 'Azerty1!' }

      before { do_request }

      it { is_expected.to have_http_status(:no_content) }
      its(:body) { is_expected.to be_blank }
    end

    context 'when current_password is wrong' do
      let(:current_password) { 'qwerty' }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.profile.update.failure', locale: user.locale)
          ]
        }
      end

      before { do_request }

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { expect(json_response).to eq(expected_response) }
    end
  end
end
