# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home' do
  include Schematics::Engine.routes.url_helpers
  include_context 'with authenticated user'

  let(:accept_header) { 'text/html' }

  describe 'GET #index' do
    let(:do_request) { get(root_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end

  describe 'DELETE #destroy' do
    let(:do_request) { delete(logout_path, headers:) }

    before { do_request }

    it { is_expected.to redirect_to(login_path) }
  end
end
