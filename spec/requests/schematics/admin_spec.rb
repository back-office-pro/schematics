# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin' do
  include Schematics::Engine.routes.url_helpers
  include_context 'with authenticated user'

  let(:accept_header) { 'text/html' }

  describe 'GET #index' do
    let(:do_request) { get(admin_path, headers:) }

    before do
      Subscription.instance.save!
      do_request
    end

    it { is_expected.to have_http_status(:success) }
  end
end
