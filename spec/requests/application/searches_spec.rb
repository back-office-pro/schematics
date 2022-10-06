# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Searches' do
  include_context 'with authenticated user'

  let(:query) { 'John Doe' }

  describe 'GET #show' do
    let(:do_request) { get(search_path(query), headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end
end
