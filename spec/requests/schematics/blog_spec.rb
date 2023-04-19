# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Blog' do
  include_context 'with unauthenticated user'

  let(:post) { BlogPost.create!(title: 'My Title', content: 'My Content', author: user) }
  let(:accept_header) { 'text/html' }

  before { post }

  describe 'GET #index' do
    let(:do_request) { get(blog_index_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end

  describe 'GET #show' do
    let(:do_request) { get(blog_path(post), headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end
end
