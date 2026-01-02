# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profile' do
  include_context 'with authenticated user'

  describe 'PUT #update' do
    let(:do_request) { put(profile_path, params:, headers:) }
    let(:params) do
      {
        user: {
          password_challenge:,
          first_name: 'John',
          last_name: 'Doe',
          locale: 'en'
        }
      }
    end

    context 'when password_challenge is right' do
      let(:password_challenge) { Schematics::Attributes::Digest::DEFAULT }

      before { do_request }

      it { is_expected.to have_http_status(:no_content) }
      its(:body) { is_expected.to be_blank }
    end

    context 'when password_challenge is wrong' do
      let(:password_challenge) { 'qwerty' }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.profile.update.failure', locale: user.locale)
          ]
        }
      end

      before { do_request }

      it { is_expected.to have_http_status(:unprocessable_content) }
      its(:parsed_body) { is_expected.to eq(expected_response) }
    end
  end
end
