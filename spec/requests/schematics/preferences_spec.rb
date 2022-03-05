# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Preferences' do
  include_context 'with authenticated user'

  describe 'PUT #update' do
    let(:do_request) { put(preferences_path, params:, headers:) }
    let(:params) { { preferences: { theme: 'light' } } }

    it { is_expected.to have_http_status(:no_content) }
    its(:body) { is_expected.to be_blank }
  end
end
