# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::Session::AuthorizedByQuery do
  subject(:query) { described_class }

  include_context 'with user'

  let(:session) { Session.create!(user:, updated_at:) }

  before { session }

  describe '.call' do
    subject { query.call(auth_token, session_id) }

    context 'when auth_token and session do not exist' do
      let(:auth_token) { nil }
      let(:session_id) { nil }
      let(:updated_at) { Time.current }

      it { is_expected.to be_empty }
    end

    context 'when auth_token does not exist and session has expired' do
      let(:auth_token) { nil }
      let(:session_id) { session.id }
      let(:updated_at) { Time.current - Application::Session::ACTIVE_DELAY }

      it { is_expected.to be_empty }
    end

    context 'when auth_token does not exist but session is active' do
      let(:auth_token) { nil }
      let(:session_id) { session.id }
      let(:updated_at) { Time.current }

      it { is_expected.to eq([session]) }
    end

    context 'when auth_token is right but session does not exist' do
      let(:auth_token) { session.auth_token }
      let(:session_id) { nil }
      let(:updated_at) { Time.current }

      it { is_expected.to eq([session]) }
    end

    context 'when auth_token is right and session is active' do
      let(:auth_token) { session.auth_token }
      let(:session_id) { session.id }
      let(:updated_at) { Time.current }

      it { is_expected.to eq([session]) }
    end

    context 'when auth_token is right but session has expired' do
      let(:auth_token) { session.auth_token }
      let(:session_id) { session.id }
      let(:updated_at) { Time.current - Application::Session::ACTIVE_DELAY }

      it { is_expected.to eq([session]) }
    end
  end
end
