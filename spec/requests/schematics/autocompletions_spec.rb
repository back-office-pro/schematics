# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Autocompletions' do
  include_context 'with authenticated user'
  include_context 'with admin role'

  let(:role) { admin_role }

  describe 'POST #create' do
    let(:do_request) { post(user_autocompletions_path, params:, headers:) }
    let(:params) { { autocompletion: { field: 'email' } } }

    before { do_request }

    it { is_expected.to have_http_status(:created) }
    its(:body) { is_expected.to eq(['john.doe@nowhere.com']) }
  end
end
