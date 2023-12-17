# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sitemap' do
  include_context 'with unauthenticated user'

  describe 'GET #show' do
    let(:do_request) { get(sitemap_path, headers:) }
    let(:accept_header) { 'application/xml' }
    let(:available_locales) { I18n.available_locales.map(&:to_s) }

    before do
      Configuration.instance.update!(available_locales:, blog_feature_flag: true)
      do_request
    end

    it { is_expected.to have_http_status(:success) }
  end
end
