# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard' do
  include_context 'with authenticated user'

  let(:role) { admin_role }
  let(:headers) { { 'Authorization' => "Bearer #{auth_token}" } }

  describe 'GET #admin' do
    let(:do_request) { get(admin_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end

  describe 'GET #home' do
    let(:do_request) { get(root_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end

  describe 'GET #logout' do
    let(:do_request) { get(logout_path, headers:) }

    before { do_request }

    it { is_expected.to redirect_to(login_path) }
  end
end
