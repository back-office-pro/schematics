# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::VersionAbility do
  subject(:ability) { described_class.new(user) }

  let(:role) { Role.new }
  let(:user) { User.new(role:) }
  let(:other_user) { User.new(role:) }
  let(:version) { Schematics::Version.new(user: version_user, object:) }
  let(:mention_version) { Schematics::Version.new(user:, event: 'mention') }

  it { is_expected.to be_able_to(:read, mention_version) }

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
