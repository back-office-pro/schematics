# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Sessions::ActiveQuery do
  include ActiveSupport::Testing::TimeHelpers

  include_context 'with user'

  let(:first_session) { Session.create!(user:) }
  let(:second_session) { Session.create!(user:) }
  let(:time) { Session::ACTIVE_DELAY.ago }

  before { [first_session, travel_to(time) { second_session }] }

  its(:call) { is_expected.to contain_exactly(first_session) }
end
