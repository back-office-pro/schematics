# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BulkActions' do
  include Schematics::ResourcesHelper

  include_context 'with authenticated user'
  include_context 'with admin role'

  let(:role) { admin_role }

  describe 'POST #create' do
    let(:do_request) { post(bulk_resource_path(User), params:, headers:) }
    let(:params) { { bulk_action: { ids: [user.id] } } }

    before { do_request }

    it { is_expected.to have_http_status(:created) }
    its(:body) { is_expected.to eq('null') }
  end
end
