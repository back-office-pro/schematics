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

RSpec.describe ActiveStorage::AttachmentAbility do
  subject(:ability) { described_class.new(user) }

  let(:role) { Role.new }
  let(:user) { User.new(role:) }
  let(:record_type) { 'ActiveStorage::VariantRecord' }

  it { is_expected.not_to be_able_to(:destroy, ActiveStorage::Attachment, record_type: 'Import') }
  it { is_expected.not_to be_able_to(:read, ActiveStorage::Attachment, record_type:) }
end
