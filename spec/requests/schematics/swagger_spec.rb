# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Swagger' do
  include_context 'with authenticated user'

  describe 'GET #show' do
    let(:do_request) { get(open_api_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:no_content) }
  end
end
