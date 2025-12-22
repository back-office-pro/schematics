# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin' do
  include_context 'with authenticated user'

  let(:accept_header) { 'text/html' }

  describe 'GET #index' do
    let(:do_request) { get(admin_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end
end
