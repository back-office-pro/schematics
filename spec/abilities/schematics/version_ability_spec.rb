# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::VersionAbility do
  subject(:ability) { described_class.new(user) }

  let(:role) { build(:role) }
  let(:user) { build(:user, role:) }
  let(:other_user) { build(:user, role:) }
  let(:version) { Schematics::Version.new(user: version_user, object:) }

  context 'when the version belongs to the user and object is present' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:version_user) { user }
    let(:object) { {} }

    it { is_expected.to be_able_to(:revert, version) }
  end

  context 'when the version belongs to the user but the object is nil' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:version_user) { user }
    let(:object) { nil }

    it { is_expected.not_to be_able_to(:revert, version) }
  end

  context 'when the version does not belong to the user and object is present' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:version_user) { other_user }
    let(:object) { {} }

    it { is_expected.not_to be_able_to(:revert, version) }
  end
end
