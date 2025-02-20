# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sudos' do
  include Schematics::Engine.routes.url_helpers
  include_context 'with authenticated user'

  describe 'POST #create' do
    let(:do_request) { post(sudos_path, params:, headers:) }
    let(:params) { { user: { password: } } }

    context 'when password is correct' do
      let(:password) { Schematics::Attributes::Digest::DEFAULT }

      before { do_request }

      it { is_expected.to have_http_status(:created) }
      its(:body) { is_expected.to eq('null') }
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
