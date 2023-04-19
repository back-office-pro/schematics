# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sitemap' do
  include_context 'with unauthenticated user'

  describe 'GET #show' do
    let(:do_request) { get(sitemap_path, headers:) }
    let(:accept_header) { 'application/xml' }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end
end
