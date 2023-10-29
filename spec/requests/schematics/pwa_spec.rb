# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PWA' do
  include_context 'with unauthenticated user'

  describe 'GET #service_worker' do
    let(:do_request) { get(service_worker_path, headers:) }
    let(:accept_header) { 'text/javascript' }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end

  describe 'GET #manifest' do
    let(:do_request) { get(manifest_path, headers:) }
    let(:expected_response) do
      {
        'background_color' => '#2c3e50',
        'display' => 'standalone',
        'icons' => [
          {
            'sizes' => 'any',
            'src' => String,
            'type' => 'image/svg+xml'
          }
        ],
        'id' => '/',
        'name' => String,
        'scope' => '/',
        'short_name' => String,
        'start_url' => '/',
        'theme_color' => '#2c3e50'
      }
    end

    before { do_request }

    it { is_expected.to have_http_status(:success) }
    it { expect(json_response).to match(expected_response) }
  end
end
