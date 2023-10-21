# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Sessions::AuthorizedByQuery do
  include ActiveSupport::Testing::TimeHelpers

  subject(:query) { described_class }

  include_context 'with user'

  let(:session) { Session.create!(user:) }

  before { travel_to(time) { session } }

  describe '.call' do
    subject { query.call(auth_token, session_id) }

    context 'when auth_token and session do not exist' do
      let(:auth_token) { nil }
      let(:session_id) { nil }
      let(:time) { Time.current }

      it { is_expected.to be_empty }
    end

    context 'when auth_token does not exist and session has expired' do
      let(:auth_token) { nil }
      let(:session_id) { session.id }
      let(:time) { Time.current - Session::ACTIVE_DELAY }

      it { is_expected.to be_empty }
    end

    context 'when auth_token does not exist but session is active' do
      let(:auth_token) { nil }
      let(:session_id) { session.id }
      let(:time) { Time.current }

      it { is_expected.to eq([session]) }
    end

    context 'when auth_token is right but session does not exist' do
      let(:auth_token) { session.auth_token }
      let(:session_id) { nil }
      let(:time) { Time.current }

      it { is_expected.to eq([session]) }
    end

    context 'when auth_token is right and session is active' do
      let(:auth_token) { session.auth_token }
      let(:session_id) { session.id }
      let(:time) { Time.current }

      it { is_expected.to eq([session]) }
    end

    context 'when auth_token is right but session has expired' do
      let(:auth_token) { session.auth_token }
      let(:session_id) { session.id }
      let(:time) { Time.current - Session::ACTIVE_DELAY }

      it { is_expected.to eq([session]) }
    end
  end
end
