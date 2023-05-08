# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::LicenceAbility do
  subject(:ability) { described_class.new(user) }

  let(:role) { Core::Role.new }
  let(:user) { Core::User.new(role:) }
  let(:permissions) { Core::Permission.create_entities_permissions! }
  let(:admin_role) { Core::Role.create!(name: 'Admin', permissions:) }

  it { is_expected.not_to be_able_to(:cancel, Core::Licence) }
  it { is_expected.not_to be_able_to(:enable, Core::Licence) }

  context 'when user is admin' do
    let(:role) { admin_role }

    it { is_expected.to be_able_to(:cancel, Core::Licence) }
    it { is_expected.to be_able_to(:enable, Core::Licence) }
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

    it { is_expected.not_to be_able_to(:create, Core::User) }
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
