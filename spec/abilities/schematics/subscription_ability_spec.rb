# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::SubscriptionAbility do
  subject(:ability) { described_class.new(user) }

  include_context 'with admin role'

  let(:role) { Role.new }
  let(:user) { User.new(role:) }

  it { is_expected.not_to be_able_to(:cancel, Subscription) }
  it { is_expected.not_to be_able_to(:enable, Subscription) }

  context 'when user is admin' do
    let(:role) { admin_role }

    it { is_expected.to be_able_to(:cancel, Subscription) }
    it { is_expected.to be_able_to(:enable, Subscription) }
  end

  context 'when users quota is exceeded' do
    before { allow(User).to receive(:count).and_return(100) }

    it { is_expected.not_to be_able_to(:create, User) }
    it { is_expected.not_to be_able_to(:restore, User) }
  end

  context 'when api keys quota is exceeded' do
    before { allow(APIKey).to receive(:count).and_return(100) }

    it { is_expected.not_to be_able_to(:create, APIKey) }
    it { is_expected.not_to be_able_to(:restore, APIKey) }
  end

  context 'when subscription is inactive' do
    before { Subscription.instance.state_inactive! }

    it { is_expected.not_to be_able_to(:create, :all) }
    it { is_expected.not_to be_able_to(:restore, :all) }
    it { is_expected.not_to be_able_to(:update, :all) }
  end
end
