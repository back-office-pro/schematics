# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MessageReplies' do
  include_context 'with authenticated user'

  describe 'POST #create' do
    let(:do_request) { post(message_replies_path(message), params:, headers:) }
    let(:params) { { message: { content: } } }
    let(:message) { Message.create!(subject: 'Foo', content:, author: user, recipients: [user]) }
    let(:content) { 'Lorem' }

    before { do_request }

    it { is_expected.to have_http_status(:created) }
  end
end
