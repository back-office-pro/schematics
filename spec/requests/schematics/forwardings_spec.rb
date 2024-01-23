# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Forwardings' do
  include_context 'with authenticated user'
  include_context 'with admin role'

  let(:role) { admin_role }

  describe 'POST #create' do
    let(:do_request) { post(user_forwardings_path(user), params:, headers:) }
    let(:params) { { forwarding: { recipient_ids: [user.id] } } }

    before { do_request }

    it { is_expected.to have_http_status(:created) }
    its(:body) { is_expected.to eq('null') }
  end
end
