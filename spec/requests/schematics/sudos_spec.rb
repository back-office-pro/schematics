# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sudos' do
  include_context 'with authenticated user'

  describe 'POST #create' do
    let(:do_request) { post(sudos_path, params:, headers:) }
    let(:params) { { user: { password: } } }

    context 'when password is correct' do
      let(:password) { Schematics::Attributes::Digest::DEFAULT }

      before { do_request }

      it { is_expected.to have_http_status(:created) }
      its(:body) { is_expected.to be_blank }
    end

    context 'when password is wrong' do
      let(:password) { 'qwerty' }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.sudos.create.failure')
          ]
        }
      end

      before { do_request }

      it { is_expected.to have_http_status(:unprocessable_content) }
      its(:parsed_body) { is_expected.to eq(expected_response) }
    end
  end
end
