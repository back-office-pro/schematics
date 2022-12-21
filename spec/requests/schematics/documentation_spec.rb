# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Documentation' do
  include_context 'with authenticated user'

  let(:role) { admin_role }

  describe 'GET #show' do
    let(:do_request) { get(documentation_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end
end
