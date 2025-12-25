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

RSpec.describe Schematics::UserAbility do
  subject(:ability) { described_class.new(user) }

  include_context 'with admin role'

  let(:role) { Role.new }
  let(:user) { User.new(role:) }

  it { is_expected.not_to be_able_to(:impersonate, User) }
  it { is_expected.not_to be_able_to(:impersonate, user) }
  it { is_expected.to be_able_to(:update, user) }
  it { is_expected.not_to be_able_to(:update, user, :role) }
  it { is_expected.not_to be_able_to(:update, user, :role_id) }
  it { is_expected.not_to be_able_to(:update, user, :teams) }
  it { is_expected.not_to be_able_to(:update, user, :team_ids) }
  it { is_expected.not_to be_able_to(:destroy, user) }
  it { is_expected.not_to be_able_to(:archive, user) }

  context 'when user is admin' do
    let(:role) { admin_role }

    it { is_expected.to be_able_to(:impersonate, User) }
    it { is_expected.not_to be_able_to(:impersonate, user) }
  end
end
