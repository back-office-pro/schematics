# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::LicenceAbility do
  subject(:ability) { described_class.new }

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
  end

  context 'when licence is inactive' do
    before do
      allow(Licence.instance)
        .to receive(:active?)
        .and_return(false)
    end

    it { is_expected.not_to be_able_to(:create, :all) }
    it { is_expected.not_to be_able_to(:update, :all) }
  end
end
