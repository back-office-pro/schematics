# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Preferences' do
  include_context 'with authenticated user'

  describe 'GET #edit' do
    let(:do_request) { get(edit_preferences_path, headers:) }
    let(:accept_header) { 'text/html' }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end

  describe 'PUT #update' do
    let(:do_request) { put(preferences_path, params:, headers:) }
    let(:params) { { user: { preferences: { theme: 'light' } } } }

    before { do_request }

    it { is_expected.to have_http_status(:no_content) }
    its(:body) { is_expected.to be_blank }
  end
end
