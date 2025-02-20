# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Emojis' do
  include Schematics::Engine.routes.url_helpers
  include_context 'with authenticated user'

  describe 'GET #index' do
    let(:do_request) { get(emojis_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:success) }
  end
end
