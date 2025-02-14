# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserNotifications' do
  include Schematics::Engine.routes.url_helpers
  include_context 'with authenticated user'

  describe 'PUT #update' do
    let(:do_request) { put(user_notifications_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:no_content) }
    its(:body) { is_expected.to be_blank }
  end
end
