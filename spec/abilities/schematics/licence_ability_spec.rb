# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::LicenceAbility do
  subject(:ability) { described_class.new(user) }

  include_context 'with admin role'

  let(:role) { Role.new }
  let(:user) { User.new(role:) }

  it { is_expected.not_to be_able_to(:cancel, Licence) }
  it { is_expected.not_to be_able_to(:enable, Licence) }

  context 'when user is admin' do
    let(:role) { admin_role }

    it { is_expected.to be_able_to(:cancel, Licence) }
    it { is_expected.to be_able_to(:enable, Licence) }
  end

  context 'when storage quota is exceeded' do
    before do
      allow(Licence.instance)
        .to receive(:quota_storage_exceeded?)
        .and_return(true)
    end

    it { is_expected.not_to be_able_to(:create, ActiveStorage::Attachment) }
  end

  context 'when users quota is exceeded' do
    before do
      allow(Licence.instance)
        .to receive(:quota_users_exceeded?)
        .and_return(true)
    end

    it { is_expected.not_to be_able_to(:create, User) }
    it { is_expected.not_to be_able_to(:restore, User) }
  end

  context 'when api keys quota is exceeded' do
    before do
      allow(Licence.instance)
        .to receive(:quota_api_keys_exceeded?)
        .and_return(true)
    end

    it { is_expected.not_to be_able_to(:create, ApiKey) }
    it { is_expected.not_to be_able_to(:restore, ApiKey) }
  end

  context 'when licence is inactive' do
    before do
      allow(Licence.instance)
        .to receive(:state_inactive?)
        .and_return(true)
    end

    it { is_expected.not_to be_able_to(:create, :all) }
    it { is_expected.not_to be_able_to(:update, :all) }
  end
end
