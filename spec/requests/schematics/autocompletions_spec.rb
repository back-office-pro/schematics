# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Autocompletions' do
  include_context 'with authenticated user'
  include_context 'with admin role'

  let(:role) { admin_role }

  describe 'POST #create' do
    let(:do_request) { post(path, params:, headers:) }
    let(:path) { user_autocompletions_path(filter: { query => 'john' }) }
    let(:params) { { autocompletion: { query: } } }
    let(:query) { 'email' }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
    its(:parsed_body) { is_expected.to eq(['john.doe@nowhere.com']) }
  end
end
