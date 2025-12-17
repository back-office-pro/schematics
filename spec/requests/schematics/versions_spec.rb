# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Versions' do
  include_context 'with authenticated user'
  include_context 'with admin role'

  let(:role) { admin_role }
  let(:headers_with_etag) { headers.merge('If-None-Match' => response.headers['ETag']) }
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
    let(:do_second_request) { get(versions_path, headers: headers_with_etag) }

    before { do_request }

    context 'when requesting once' do
      it { is_expected.to have_http_status(:success) }
    end

    context 'when requesting twice' do
      before { do_second_request }

      it { is_expected.to have_http_status(:not_modified) }
    end
  end

  describe 'GET #show' do
    let(:do_request) { get(version_path(version), headers:) }
    let(:do_second_request) { get(version_path(version), headers: headers_with_etag) }

    before { do_request }

    context 'when requesting once' do
      it { is_expected.to have_http_status(:success) }
    end

    context 'when requesting twice' do
      before { do_second_request }

      it { is_expected.to have_http_status(:not_modified) }
    end
  end

  describe 'PATCH #revert' do
    let(:do_request) { patch(revert_version_path(version), headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:no_content) }
  end
end
