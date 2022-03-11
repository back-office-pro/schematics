# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::LicenceAbility do
  subject(:ability) { described_class.new(licence) }

  let(:licence) { Licence.instance }

  context 'when storage quota is exceeded' do
    before { allow(Licence.instance).to receive(:quota_storage_exceeded?).and_return(true) }

    it { is_expected.not_to be_able_to(:create, ActiveStorage::Attachment) }
  end

  context 'when users quota is exceeded' do
    before { allow(Licence.instance).to receive(:quota_users_exceeded?).and_return(true) }

    it { is_expected.not_to be_able_to(:create, User) }
  end

  context 'when licence is expired' do
    before { allow(Licence.instance).to receive(:expired?).and_return(true) }

    it { is_expected.not_to be_able_to(:manage, :all) }
  end
end
