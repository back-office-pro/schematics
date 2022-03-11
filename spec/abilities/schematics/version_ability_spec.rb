# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::VersionAbility do
  subject(:ability) { described_class.new(user) }

  fixtures :users
  fixtures :roles
  fixtures :permissions

  let(:user) { users(:one) }
  let(:other_user) { users(:two) }
  let(:version) { Schematics::Version.new(user: version_user, object:) }

  context 'when the version belongs to the user and object is present' do
    let(:version_user) { user }
    let(:object) { {} }

    it { is_expected.to be_able_to(:revert, version) }
  end

  context 'when the version belongs to the user but the object is nil' do
    let(:version_user) { user }
    let(:object) { nil }

    it { is_expected.not_to be_able_to(:revert, version) }
  end

  context 'when the version does not belong to the user and object is present' do
    let(:version_user) { other_user }
    let(:object) { {} }

    it { is_expected.not_to be_able_to(:revert, version) }
  end
end
