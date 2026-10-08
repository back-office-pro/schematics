# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Emojis' do
  include_context 'with authenticated user'

  describe 'GET #index' do
    let(:do_request) { get(emojis_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end
end
