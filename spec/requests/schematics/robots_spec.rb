# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Robots' do
  include Schematics::Engine.routes.url_helpers
  include_context 'with unauthenticated user'

  describe 'GET #index' do
    let(:do_request) { get(robots_path, headers:) }
    let(:accept_header) { 'text/plain' }
    let(:expected_response) do
      <<~TEXT
        User-agent: *
        Disallow: /
      TEXT
    end

    before { do_request }

    it { is_expected.to have_http_status(:success) }
    its(:body) { is_expected.to eq(expected_response) }
  end
end
