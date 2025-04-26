# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Guest::Session do
  subject(:session) { described_class.new(request:) }

  include_context 'with user'

  let(:request) { ActionController::TestRequest.create({}) }

  before { request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-US' }

  it { is_expected.not_to be_sudo }

  its(:locale) { is_expected.to eq(:en) }
  its(:remote_ip) { is_expected.to eq('0.0.0.0') }
  its(:user_agent) { is_expected.to eq('Rails Testing') }
  its(:touch!) { is_expected.to be_truthy }

  describe '#user' do
    subject { session.user }

    it { is_expected.to be_a(Schematics::Guest::User) }
    its(:locale) { is_expected.to eq(:en) }
  end

  describe '#login!' do
    subject { session.login!(user) }

    it { is_expected.to be_a(Session) }
    its(:ip) { is_expected.to eq('0.0.0.0') }
    its(:user_agent) { is_expected.to eq('Rails Testing') }
    its(:user) { is_expected.to eq(user) }
  end
end
