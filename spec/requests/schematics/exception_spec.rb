# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Exception' do
  include Schematics::Engine.routes.url_helpers
  include_context 'with unauthenticated user'

  describe '404' do
    let(:do_request) { get(not_found_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:not_found) }
    its(:body) { is_expected.to eq('null') }
  end

  describe '500' do
    let(:do_request) { get(internal_server_error_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:internal_server_error) }
    its(:body) { is_expected.to eq('null') }
  end

  describe '503' do
    let(:do_request) { get(maintenance_mode_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:service_unavailable) }
    its(:body) { is_expected.to eq('null') }
  end
end
