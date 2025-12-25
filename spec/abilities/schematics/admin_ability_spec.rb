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

RSpec.describe Schematics::AdminAbility do
  subject(:ability) { described_class.new(parent_ability) }

  let(:parent_ability) { Schematics::Ability.new(user) }
  let(:user) { User.new(role:) }
  let(:role) { Role.new(permissions:) }
  let(:permissions) { [] }

  it { is_expected.not_to be_able_to(:index, :admin) }

  context 'when one of the requested ability is present' do
    let(:permissions) { [Permission.new(action: 'index', model: 'Permission')] }

    it { is_expected.to be_able_to(:index, :admin) }
  end
end
