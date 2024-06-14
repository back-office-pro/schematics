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
    before do
      allow(Subscription)
        .to receive(:quota_users_exceeded?)
        .and_return(true)
    end

    it { is_expected.not_to be_able_to(:create, User) }
    it { is_expected.not_to be_able_to(:restore, User) }
  end

  context 'when api keys quota is exceeded' do
    before do
      allow(Subscription)
        .to receive(:quota_api_keys_exceeded?)
        .and_return(true)
    end

    it { is_expected.not_to be_able_to(:create, APIKey) }
    it { is_expected.not_to be_able_to(:restore, APIKey) }
  end

  context 'when subscription is inactive' do
    before do
      allow(Subscription.instance)
        .to receive(:state_inactive?)
        .and_return(true)
    end

    it { is_expected.not_to be_able_to(:create, :all) }
    it { is_expected.not_to be_able_to(:restore, :all) }
    it { is_expected.not_to be_able_to(:update, :all) }
  end
end
