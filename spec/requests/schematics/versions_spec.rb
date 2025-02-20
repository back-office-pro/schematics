# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Versions' do
  include Schematics::Engine.routes.url_helpers
  include_context 'with authenticated user'
  include_context 'with admin role'

  let(:role) { admin_role }
  let(:version) do
    Schematics::Version.create!(
      event: 'update',
      item: user,
      user:,
      object: user.as_json
    )
  end

  describe 'GET #index' do
    let(:do_request) { get(versions_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end

  describe 'GET #show' do
    let(:do_request) { get(version_path(version), headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end

  describe 'PATCH #revert' do
    let(:do_request) { patch(revert_version_path(version), headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:no_content) }
  end
end
