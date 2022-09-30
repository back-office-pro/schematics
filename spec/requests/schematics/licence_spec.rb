# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Licence' do
  include_context 'with authenticated user'

  let(:role) { admin_role }

  describe 'DELETE #destroy' do
    let(:do_request) { delete(licence_path, headers:) }

    before { do_request }

    it { is_expected.to have_http_status(:no_content) }
  end
end
