# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Sessions::AuthorizedByQuery do
  include ActiveSupport::Testing::TimeHelpers

  subject(:query) { described_class }

  include_context 'with user'

  let(:session) { Session.create!(user:) }

  before { travel_to(time) { session } }

  describe '.call' do
    subject { query.call(access_token, session_id) }

    context 'when access_token and session do not exist' do
      let(:access_token) { nil }
      let(:session_id) { nil }
      let(:time) { Time.current }

      it { is_expected.to be_empty }
    end

    context 'when access_token does not exist and session has expired' do
      let(:access_token) { nil }
      let(:session_id) { session.id }
      let(:time) { Session::ACTIVE_DELAY.ago }

      it { is_expected.to be_empty }
    end

    context 'when access_token does not exist but session is active' do
      let(:access_token) { nil }
      let(:session_id) { session.id }
      let(:time) { Time.current }

      it { is_expected.to eq([session]) }
    end

    context 'when access_token is right but session does not exist' do
      let(:access_token) { session.id }
      let(:session_id) { nil }
      let(:time) { Time.current }

      it { is_expected.to eq([session]) }
    end

    context 'when access_token is right and session is active' do
      let(:access_token) { session.id }
      let(:session_id) { session.id }
      let(:time) { Time.current }

      it { is_expected.to eq([session]) }
    end

    context 'when access_token is right but session has expired' do
      let(:access_token) { session.id }
      let(:session_id) { session.id }
      let(:time) { Session::ACTIVE_DELAY.ago }

      it { is_expected.to eq([session]) }
    end
  end
end
