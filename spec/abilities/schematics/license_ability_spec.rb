# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::LicenseAbility do
  subject(:ability) { described_class.new }

  context 'when license is not active' do
    before { allow(Configuration).to receive(:license).and_call_original }

    it { is_expected.not_to be_able_to(:create, Backup) }
  end

  context 'when users quota is exceeded' do
    before { allow(User).to receive(:count).and_return(100) }

    it { is_expected.not_to be_able_to(:create, User) }
    it { is_expected.not_to be_able_to(:restore, User) }
  end

  context 'when webhooks quota is exceeded' do
    before { allow(WebhookEndpoint).to receive(:count).and_return(100) }

    it { is_expected.not_to be_able_to(:create, WebhookEndpoint) }
    it { is_expected.not_to be_able_to(:restore, WebhookEndpoint) }
  end

  context 'when api keys quota is exceeded' do
    before { allow(APIKey).to receive(:count).and_return(100) }

    it { is_expected.not_to be_able_to(:create, APIKey) }
    it { is_expected.not_to be_able_to(:restore, APIKey) }
  end

  context 'when roles quota is exceeded' do
    before { allow(Role).to receive(:count).and_return(100) }

    it { is_expected.not_to be_able_to(:create, Role) }
    it { is_expected.not_to be_able_to(:restore, Role) }
  end

  context 'when teams quota is exceeded' do
    before { allow(Team).to receive(:count).and_return(100) }

    it { is_expected.not_to be_able_to(:create, Team) }
    it { is_expected.not_to be_able_to(:restore, Team) }
  end
end
